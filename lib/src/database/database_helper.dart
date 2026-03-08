import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../features/medicine/data/models/medicine_model.dart';
import '../features/history/data/models/dose_history_model.dart';
import '../features/settings/data/models/profile_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'doctordaily.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage REAL NOT NULL,
        frequency TEXT NOT NULL,
        stock REAL NOT NULL,
        "taken_today" INTEGER DEFAULT 0,
        "remaining_doses" INTEGER DEFAULT 0,
        "scheduled_time" TEXT,
        "is_completed" INTEGER DEFAULT 0,
        startDate TEXT NOT NULL,
        endDate TEXT,
        notes TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE dose_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicineId INTEGER NOT NULL,
        date TEXT NOT NULL,
        taken INTEGER NOT NULL,
        FOREIGN KEY(medicineId) REFERENCES medicines(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE profile(
        id INTEGER PRIMARY KEY NOT NULL, 
        name TEXT, 
        age INTEGER, 
        weight REAL, 
        height REAL
      )
    ''');
  }

  // Medicine CRUD
  Future<void> addMedicine(Medicine medicine) async {
    final db = await database;
    await db.insert('medicines', medicine.toMap());
  }

  Future<List<Medicine>> getActiveMedicines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medicines',
      where: 'stock > 0 AND (endDate IS NULL OR date(endDate) >= date(\'now\', \'start of day\'))',
      orderBy: 'name DESC',
    );
    return List.generate(maps.length, (i) {
      return Medicine.fromMap(maps[i]);
    });
  }

  Future<Medicine?> getMedicineById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('medicines', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Medicine.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateMedicine(Medicine medicine) async {
    final db = await database;
    await db.update('medicines', medicine.toMap(), where: 'id = ?', whereArgs: [medicine.id]);
  }

  Future<void> deleteMedicine(int id) async {
    final db = await database;
    await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }

  // Dose History CRUD
  Future<void> addDoseHistory(DoseHistory doseHistory) async {
    final db = await database;
    await db.insert('dose_history', doseHistory.toMap());
  }
  
  Future<void> skipDose(int medicineId, DateTime scheduledTime) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('dose_history', {
        'medicineId': medicineId,
        'date': scheduledTime.toIso8601String(),
        'taken': 0,
      });
    });
  }

  Future<void> takeDoseAndUpdateInventory(int medicineId, DateTime scheduledTime, double doseValue) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('dose_history', {
        'medicineId': medicineId,
        'date': DateTime.now().toIso8601String(),
        'taken': 1,
      });
      await txn.rawUpdate(
        'UPDATE medicines SET stock = stock - ? WHERE id = ? AND stock >= ?',
        [doseValue, medicineId, doseValue],
      );
    });
  }

  Future<List<DoseHistory>> getAllProcessedDoses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dose_history',
      where: "taken = 1 OR taken = 0",
    );
    return List.generate(maps.length, (i) {
      return DoseHistory.fromMap(maps[i]);
    });
  }
  
  // Profile CRUD
  Future<void> saveProfile(Profile profile) async {
    final db = await database;
    await db.insert('profile', profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Profile?> getProfile() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('profile');
    if (maps.isNotEmpty) {
      return Profile.fromMap(maps.first);
    }
    return null;
  }


  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'doctordaily.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}

class MedicineService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> takeDose(int medicineId) async {
    final medicine = await _dbHelper.getMedicineById(medicineId);
    if (medicine == null) {
      return;
    }

    if (medicine.stock <= 0) {
      // Show a warning
      return;
    }

    if (medicine.endDate != null && DateTime.parse(medicine.endDate!).isBefore(DateTime.now())) {
      // Do not allow taking doses after endDate
      return;
    }

    // Insert a new record in dose_history with taken = 1
    final doseHistory = DoseHistory(
      medicineId: medicineId,
      date: DateTime.now().toIso8601String(),
      taken: 1,
    );
    await _dbHelper.addDoseHistory(doseHistory);

    // Subtract the taken dose from the stock in medicines
    final newStock = medicine.stock - medicine.dosage;
    final isCompleted = newStock <= 0;
    final takenToday = medicine.takenToday + 1;
    final remainingDoses = int.parse(medicine.frequency) - takenToday;

    final updatedMedicine = Medicine(
      id: medicine.id,
      name: medicine.name,
      dosage: medicine.dosage,
      frequency: medicine.frequency,
      stock: newStock,
      takenToday: takenToday,
      remainingDoses: remainingDoses,
      scheduledTime: medicine.scheduledTime,
      isCompleted: isCompleted,
      startDate: medicine.startDate,
      endDate: medicine.endDate,
      notes: medicine.notes,
    );
    await _dbHelper.updateMedicine(updatedMedicine);
  }

  Future<void> checkMissedDoses() async {
    final activeMedicines = await _dbHelper.getActiveMedicines();
    for (final medicine in activeMedicines) {
      if (medicine.scheduledTime != null) {
        final scheduledTime = DateTime.parse(medicine.scheduledTime!);
        if (scheduledTime.isBefore(DateTime.now())) {
          final doses = await _dbHelper.getAllProcessedDoses();
          final takenDoses = doses.where((dose) => dose.medicineId == medicine.id && dose.date == scheduledTime.toIso8601String());
          if (takenDoses.isEmpty) {
            // Notify if a dose was missed
          }
        }
      }
    }
  }

  Future<void> checkLowStock() async {
    final activeMedicines = await _dbHelper.getActiveMedicines();
    for (final medicine in activeMedicines) {
      if (medicine.stock < 5) { // Assuming 5 is the low stock threshold
        // Notify if stock is low
      }
    }
  }
}
