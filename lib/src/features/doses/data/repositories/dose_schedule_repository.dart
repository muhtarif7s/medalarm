import 'package:myapp/src/database/database_helper.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:sqflite/sqflite.dart';

class DoseScheduleRepository {
  final dbHelper = DatabaseHelper();

  Future<void> createDoseSchedulesForMedication(Medication medication) async {
    final db = await dbHelper.database;
    final batch = db.batch();

    if (medication.endDate != null) {
      for (var date = medication.startDate;
          date.isBefore(medication.endDate!.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        for (var time in medication.times) {
          batch.insert(
            'dose_schedule',
            DoseSchedule(
              medicationId: medication.id!,
              scheduledTime: DateTime(date.year, date.month, date.day, time.hour, time.minute),
              status: DoseStatus.pending,
            ).toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    }

    await batch.commit(noResult: true);
  }

  Future<void> updateDoseSchedule(DoseSchedule doseSchedule) async {
    final db = await dbHelper.database;
    await db.update(
      'dose_schedule',
      doseSchedule.toMap(),
      where: 'id = ?',
      whereArgs: [doseSchedule.id],
    );
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

  Future<List<DoseSchedule>> getDoseSchedulesForDay(DateTime date) async {
    final db = await dbHelper.database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    final maps = await db.query(
      'dose_schedule',
      where: 'scheduledTime >= ? AND scheduledTime < ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: 'scheduledTime ASC',
    );
    return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
  }
}
