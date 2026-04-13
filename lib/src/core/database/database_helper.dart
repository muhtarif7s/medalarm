// Dart imports:
import 'dart:async';

// Package imports:
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed.
    _database = await _initDatabase();
    return _database!;
  }

  // This opens the database (and creates it if it doesn't exist).
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE medications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            dosage REAL NOT NULL,
            unit TEXT NOT NULL,
            stock INTEGER NOT NULL,
            scheduleType TEXT NOT NULL,
            times TEXT NOT NULL, -- JSON list of TimeOfDay
            startDate TEXT NOT NULL,
            remainingDoses INTEGER NOT NULL,
            daysOfWeek TEXT -- JSON list of DayOfWeek
          )
          ''');

    await db.execute('''
          CREATE TABLE dose_schedules(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicationId INTEGER NOT NULL,
            scheduledTime TEXT NOT NULL,
            status TEXT NOT NULL,
            FOREIGN KEY (medicationId) REFERENCES medications (id)
          )
          ''');

    await db.execute('''
          CREATE TABLE profile(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            avatarUrl TEXT
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryRowsByDate(String table, DateTime date) async {
    Database db = await instance.database;
    String dateString = date.toIso8601String().substring(0, 10);
    return await db.query(table, where: "strftime('%Y-%m-%d', scheduledTime) = ?", whereArgs: [dateString]);
  }

  Future<List<Map<String, dynamic>>> queryRowsByMedicationId(String table, int medicationId) async {
    Database db = await instance.database;
    return await db.query(table, where: 'medicationId = ?', whereArgs: [medicationId]);
  }

  Future<List<Map<String, dynamic>>> queryPendingDoses(String table) async {
    Database db = await instance.database;
    return await db.query(table, where: 'status = ?', whereArgs: ['pending']);
  }

   Future<Map<String, dynamic>?> getById(String table, int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query('profile');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
