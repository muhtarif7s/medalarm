// Package imports:
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/medication/models/medication.dart';

class DoseScheduleRepository {
  final Database database;

  DoseScheduleRepository({required this.database});

  Future<void> createDoseSchedulesForMedication(Medication medication) async {
    try {
      final batch = database.batch();

      if (medication.id != null) {
        DateTime endDate = medication.endDate ?? medication.startDate.add(const Duration(days: 30));
        for (var date = medication.startDate;
            date.isBefore(endDate.add(const Duration(days: 1)));
            date = date.add(const Duration(days: 1))) {
          for (var time in medication.times) {
            batch.insert(
              'dose_schedules',
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
    } catch (e) {
      throw Exception('Failed to create dose schedules: $e');
    }
  }

  Future<void> updateDoseSchedule(DoseSchedule doseSchedule) async {
    try {
      await database.update(
        'dose_schedules',
        doseSchedule.toMap(),
        where: 'id = ?',
        whereArgs: [doseSchedule.id],
      );
    } catch (e) {
      throw Exception('Failed to update dose schedule: $e');
    }
  }

  Future<void> updateDoseScheduleStatus(int id, DoseStatus status) async {
    try {
      await database.update(
        'dose_schedules',
        {'status': status.name},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to update dose schedule status: $e');
    }
  }

  Future<DoseSchedule?> getDoseSchedule(int id) async {
    try {
      final maps = await database.query('dose_schedules', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        return DoseSchedule.fromMap(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get dose schedule: $e');
    }
  }

  Future<List<DoseSchedule>> getDoseSchedulesForMedication(
      int medicationId) async {
    try {
      final maps = await database.query(
        'dose_schedules',
        where: 'medicationId = ?',
        whereArgs: [medicationId],
        orderBy: 'scheduledTime DESC',
      );
      return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to get dose schedules for medication: $e');
    }
  }

    Future<List<DoseSchedule>> getAllDoseSchedules() async {
    try {
      final maps = await database.query(
        'dose_schedules',
        orderBy: 'scheduledTime DESC',
      );
      return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to get all dose schedules: $e');
    }
  }

  Future<List<DoseSchedule>> getAllPendingDoseSchedules() async {
    try {
      final maps = await database.query(
        'dose_schedules',
        where: 'status = ?',
        whereArgs: [DoseStatus.pending.name],
        orderBy: 'scheduledTime DESC',
      );
      return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to get all pending dose schedules: $e');
    }
  }

  Future<void> deleteDoseSchedulesForMedication(int medicationId) async {
    try {
      await database.delete(
        'dose_schedules',
        where: 'medicationId = ?',
        whereArgs: [medicationId],
      );
    } catch (e) {
      throw Exception('Failed to delete dose schedules for medication: $e');
    }
  }

  Future<List<DoseSchedule>> getDoseSchedulesForDay(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final maps = await database.query(
        'dose_schedules',
        where: 'scheduledTime >= ? AND scheduledTime < ?',
        whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
        orderBy: 'scheduledTime ASC',
      );
      return List.generate(maps.length, (i) => DoseSchedule.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Failed to get dose schedules for day: $e');
    }
  }
}
