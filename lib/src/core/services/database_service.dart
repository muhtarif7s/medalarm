// Package imports:
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/medication/models/medication.dart';

abstract class DatabaseService {
  Future<void> init();
  Future<int> insertMedication(Medication medication);
  Future<List<Medication>> getMedications();
  Future<int> updateMedication(Medication medication);
  Future<int> deleteMedication(int id);

  Future<int> insertDose(Dose dose);
  Future<List<Dose>> getDoses();
}

class SqfliteDatabaseService implements DatabaseService {
  Database? _db;

  @override
  Future<void> init() async {
    final path = await getDatabasesPath();
    _db = await openDatabase(
      join(path, 'medication.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE medications(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dosage REAL, unit TEXT, stock INTEGER, scheduleType TEXT, times TEXT, daysOfWeek TEXT, interval INTEGER, startDate TEXT, endDate TEXT, remainingDoses INTEGER)',
        );
        await database.execute(
          'CREATE TABLE doses(id INTEGER PRIMARY KEY AUTOINCREMENT, medicationId INTEGER, time TEXT, status TEXT)',
        );
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await database.execute(
              'ALTER TABLE medications ADD COLUMN stock INTEGER DEFAULT 0');
          await database
              .execute('ALTER TABLE medications ADD COLUMN daysOfWeek TEXT');
          await database.execute(
              'ALTER TABLE medications ADD COLUMN remainingDoses INTEGER DEFAULT 0');
        }
      },
      version: 2,
    );
  }

  @override
  Future<int> insertMedication(Medication medication) async {
    await init();
    return await _db!.insert('medications', medication.toMap());
  }

  @override
  Future<List<Medication>> getMedications() async {
    await init();
    final List<Map<String, dynamic>> maps = await _db!.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  @override
  Future<int> updateMedication(Medication medication) async {
    await init();
    return await _db!.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  @override
  Future<int> deleteMedication(int id) async {
    await init();
    return await _db!.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> insertDose(Dose dose) async {
    await init();
    return await _db!.insert('doses', dose.toMap());
  }

  @override
  Future<List<Dose>> getDoses() async {
    await init();
    final List<Map<String, dynamic>> maps = await _db!.query('doses');
    return List.generate(maps.length, (i) {
      return Dose.fromMap(maps[i]);
    });
  }
}
