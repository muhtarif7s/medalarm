import 'package:myapp/src/database/database_helper.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class MedicationRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Medication medication) async {
    final db = await dbHelper.database;
    return await db.insert('medications', medication.toMap());
  }

  Future<List<Medication>> getAll() async {
    final db = await dbHelper.database;
    final maps = await db.query('medications');
    return maps.map((map) => Medication.fromMap(map)).toList();
  }

  Future<int> update(Medication medication) async {
    final db = await dbHelper.database;
    return await db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
