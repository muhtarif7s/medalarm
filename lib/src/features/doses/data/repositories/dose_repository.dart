// Package imports:
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:myapp/src/database/database_helper.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';

class DoseRepository {
  final dbHelper = DatabaseHelper();

  Future<void> addDose(Dose dose) async {
    final db = await dbHelper.database;
    await db.insert('doses', dose.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDoseStatus(int id, DoseStatus status) async {
    final db = await dbHelper.database;
    await db.update(
      'doses',
      {'status': status.toString().split('.').last},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Dose?> getDose(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('doses', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Dose.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Dose>> getDosesForMedication(int medicationId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'doses',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
      orderBy: 'time DESC',
    );
    return List.generate(maps.length, (i) => Dose.fromMap(maps[i]));
  }

  Future<List<Dose>> getAllDoses() async {
    final db = await dbHelper.database;
    final maps = await db.query('doses', orderBy: 'time DESC');
    return List.generate(maps.length, (i) => Dose.fromMap(maps[i]));
  }

  Future<void> deleteDosesForMedication(int medicationId) async {
    final db = await dbHelper.database;
    await db.delete(
      'doses',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
  }
}
