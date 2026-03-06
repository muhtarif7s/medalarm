import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/models/dose.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'medication_manager.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage REAL NOT NULL,
        unit TEXT NOT NULL,
        scheduleType TEXT NOT NULL,
        times TEXT NOT NULL,
        weekdays TEXT,
        interval INTEGER,
        startDate TEXT NOT NULL,
        endDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE doses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicationId INTEGER NOT NULL,
        time TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');
  }

  // Medication CRUD
  Future<int> insertMedication(Medication medication) async {
    final db = await instance.database;
    return await db.insert('medications', medication.toMap());
  }

  Future<List<Medication>> getMedications() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  Future<Medication?> getMedicationById(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMedication(Medication medication) async {
    final db = await instance.database;
    return await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  Future<int> deleteMedication(int id) async {
    final db = await instance.database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Dose CRUD
  Future<int> insertDose(Dose dose) async {
    final db = await instance.database;
    return await db.insert('doses', dose.toMap());
  }

  Future<List<Dose>> getDoses(int medicationId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'doses',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
    return List.generate(maps.length, (i) {
      return Dose.fromMap(maps[i]);
    });
  }

  Future<List<Dose>> getAllDoses() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('doses');
    return List.generate(maps.length, (i) {
      return Dose.fromMap(maps[i]);
    });
  }

  Future<int> updateDose(Dose dose) async {
    final db = await instance.database;
    return await db.update(
      'doses',
      dose.toMap(),
      where: 'id = ?',
      whereArgs: [dose.id],
    );
  }

  Future<int> deleteDose(int id) async {
    final db = await instance.database;
    return await db.delete(
      'doses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
