import 'package:myapp/src/database/database_helper.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:sqflite/sqflite.dart';

class MedicationRepository {
  final dbHelper = DatabaseHelper();

  Future<int> addMedication(Medication medication) async {
    final db = await dbHelper.database;
    return await db.insert('medications', medication.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateMedication(Medication medication) async {
    final db = await dbHelper.database;
    await db.update('medications', medication.toMap(), where: 'id = ?', whereArgs: [medication.id]);
  }

  Future<void> deleteMedication(int id) async {
    final db = await dbHelper.database;
    await db.delete('medications', where: 'id = ?', whereArgs: [id]);
    // Also delete associated doses
    await db.delete('doses', where: 'medicationId = ?', whereArgs: [id]);
  }

  Future<Medication?> getMedication(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('medications', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Medication>> getAllMedications() async {
    final db = await dbHelper.database;
    final maps = await db.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }
}
