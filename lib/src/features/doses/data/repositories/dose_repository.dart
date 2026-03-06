import 'package:myapp/src/database/database_helper.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';

class DoseRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Dose dose) async {
    final db = await dbHelper.database;
    return await db.insert('doses', dose.toMap());
  }

  Future<List<Dose>> getDosesForMedication(int medicationId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'doses',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
    return maps.map((map) => Dose.fromMap(map)).toList();
  }

  Future<int> update(Dose dose) async {
    final db = await dbHelper.database;
    return await db.update(
      'doses',
      dose.toMap(),
      where: 'id = ?',
      whereArgs: [dose.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'doses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
