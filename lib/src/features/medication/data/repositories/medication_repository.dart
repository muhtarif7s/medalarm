import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:sqflite/sqflite.dart';

class MedicationRepository {
  final Database database;
  MedicationRepository({required this.database});

  Future<int> addMedication(Medication medication) async {
    return await database.insert(
      'medications',
      medication.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMedication(Medication medication) async {
    await database.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  Future<void> deleteMedication(int id) async {
    await database.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    await deleteMedication(id);
  }

  Future<Medication?> getMedication(int id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Medication>> getAllMedicationsOnce() async {
    final List<Map<String, dynamic>> maps = await database.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }
}
