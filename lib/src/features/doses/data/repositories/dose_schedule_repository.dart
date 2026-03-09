import 'package:myapp/src/database/database_helper.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:sqflite/sqflite.dart';

class DoseScheduleRepository {
  final dbHelper = DatabaseHelper();

  Future<int> addDoseSchedule(DoseSchedule doseSchedule) async {
    final db = await dbHelper.database;
    return await db.insert('dose_schedule', doseSchedule.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDoseScheduleStatus(int id, DoseStatus status) async {
    final db = await dbHelper.database;
    await db.update(
      'dose_schedule',
      {'status': status.name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<DoseSchedule?> getDoseSchedule(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query('dose_schedule', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return DoseSchedule.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<DoseSchedule>> getDoseSchedulesForMedication(
      int medicationId) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'dose_schedule',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
      orderBy: 'scheduledTime DESC',
    );
    return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
  }

  Future<List<DoseSchedule>> getAllDoseSchedules() async {
    final db = await dbHelper.database;
    final maps = await db.query('dose_schedule', orderBy: 'scheduledTime DESC');
    return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
  }

  Future<List<DoseSchedule>> getAllPendingDoseSchedules() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'dose_schedule',
      where: 'status = ?',
      whereArgs: [DoseStatus.pending.name],
      orderBy: 'scheduledTime DESC',
    );
    return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
  }

  Future<void> deleteDoseSchedulesForMedication(int medicationId) async {
    final db = await dbHelper.database;
    await db.delete(
      'dose_schedule',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
  }
}
