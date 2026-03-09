import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

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
    try {
      String path = join(await getDatabasesPath(), 'medication_app.db');
      return await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE medications(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          dosage REAL NOT NULL,
          unit TEXT NOT NULL,
          stock INTEGER NOT NULL,
          scheduleType TEXT NOT NULL,
          times TEXT NOT NULL,
          weekdays TEXT,
          interval INTEGER,
          startDate TEXT NOT NULL,
          endDate TEXT,
          remaining_doses INTEGER NOT NULL,
          taken_today INTEGER NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE doses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          medicationId INTEGER NOT NULL,
          time TEXT NOT NULL,
          status TEXT NOT NULL,
          FOREIGN KEY(medicationId) REFERENCES medications(id) ON DELETE CASCADE
        )
      ''');
      await db.execute('''
        CREATE TABLE dose_schedule(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          medicationId INTEGER NOT NULL,
          scheduledTime TEXT NOT NULL,
          status TEXT NOT NULL,
          FOREIGN KEY(medicationId) REFERENCES medications(id) ON DELETE CASCADE
        )
      ''');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE dose_schedule(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicationId INTEGER NOT NULL,
            scheduledTime TEXT NOT NULL,
            status TEXT NOT NULL,
            FOREIGN KEY(medicationId) REFERENCES medications(id) ON DELETE CASCADE
          )
        ''');
      }
    } catch (e) {
      rethrow;
    }
  }
}
