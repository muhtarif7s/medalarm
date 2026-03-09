import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:sqflite/sqflite.dart';

class MedicationRepository {
  final Database database;

  MedicationRepository({required this.database});

  Future<int> addMedication(Medication medication) async {
    return await database.insert('medications', medication.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateMedication(Medication medication) async {
    await database.update('medications', medication.toMap(), where: 'id = ?', whereArgs: [medication.id]);
  }

  Future<void> deleteMedication(int id) async {
    await database.delete('medications', where: 'id = ?', whereArgs: [id]);
    // Also delete associated doses
    await database.delete('doses', where: 'medicationId = ?', whereArgs: [id]);
  }

  Future<Medication?> getMedication(int id) async {
    final maps = await database.query('medications', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Medication>> getAllMedications() async {
    final maps = await database.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }
}
