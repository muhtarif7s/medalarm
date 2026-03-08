
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../features/medicine/data/models/medicine_model.dart';
import '../features/history/data/models/dose_history_model.dart';

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
        notes TEXT,
        icon_name TEXT,
        color TEXT,
        dosage_amount REAL NOT NULL,
        dosage_unit TEXT NOT NULL,
        total_quantity REAL,
        remaining_quantity REAL,
        refill_reminder_at REAL,
        frequency_type TEXT NOT NULL,
        dose_times TEXT NOT NULL,
        specific_days TEXT,
        interval_days INTEGER,
        start_date TEXT NOT NULL,
        end_date TEXT,
        skip_count INTEGER DEFAULT 0 NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE dose_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicine_id INTEGER NOT NULL,
        scheduled_time TEXT NOT NULL,
        taken_at TEXT,
        status TEXT NOT NULL,
        FOREIGN KEY(medicine_id) REFERENCES medicines(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE profile(
        id INTEGER PRIMARY KEY NOT NULL, 
        firstName TEXT, 
        lastName TEXT, 
        birthDate TEXT
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
      where: '(remaining_quantity IS NULL OR remaining_quantity > 0) AND (end_date IS NULL OR date(end_date) >= date(\'now\', \'start of day\'))',
      orderBy: 'created_at DESC',
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
        'medicine_id': medicineId,
        'scheduled_time': scheduledTime.toIso8601String(),
        'status': 'skipped',
      });
      await txn.rawUpdate(
        'UPDATE medicines SET skip_count = skip_count + 1 WHERE id = ?',
        [medicineId],
      );
    });
  }

  Future<void> takeDoseAndUpdateInventory(int medicineId, DateTime scheduledTime, double doseValue) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.insert('dose_history', {
        'medicine_id': medicineId,
        'scheduled_time': scheduledTime.toIso8601String(),
        'taken_at': DateTime.now().toIso8601String(),
        'status': 'taken',
      });
      await txn.rawUpdate(
        'UPDATE medicines SET remaining_quantity = remaining_quantity - ? WHERE id = ? AND (remaining_quantity IS NULL OR remaining_quantity >= ?)',
        [doseValue, medicineId, doseValue],
      );
    });
  }

  Future<List<DoseHistory>> getAllProcessedDoses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dose_history',
      where: "status = 'taken' OR status = 'skipped'",
    );
    return List.generate(maps.length, (i) {
      return DoseHistory.fromMap(maps[i]);
    });
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'doctordaily.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
