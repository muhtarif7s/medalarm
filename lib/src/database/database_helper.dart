
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medication_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dosage REAL NOT NULL,
        unit TEXT NOT NULL,
        scheduleType INTEGER NOT NULL,
        times TEXT NOT NULL,
        weekdays TEXT,
        interval INTEGER,
        startDate TEXT NOT NULL,
        endDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE doses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medicationId INTEGER NOT NULL,
        scheduledTime TEXT NOT NULL,
        status INTEGER NOT NULL,
        actionTime TEXT,
        FOREIGN KEY (medicationId) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');
  }
}
