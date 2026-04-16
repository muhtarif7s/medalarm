import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:sqflite/sqflite.dart';

class DoseRepository {
  final Database database;

  DoseRepository({required this.database});

  Future<void> addDose(Dose dose) async {
    await database.insert('dose_schedules', dose.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDose(Dose dose) async {
    await database.update(
      'dose_schedules',
      dose.toMap(),
      where: 'id = ?',
      whereArgs: [dose.id],
    );
  }

  Future<List<Dose>> getDosesForDay(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day).toIso8601String();
    final end =
        DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();
    final maps = await database.query(
      'dose_schedules',
      where: 'scheduledTime BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: 'scheduledTime ASC',
    );
    return List.generate(maps.length, (i) => Dose.fromMap(maps[i]));
  }

  Future<List<Dose>> getAllDoses() async {
    final maps = await database.query(
      'dose_schedules',
      orderBy: 'scheduledTime ASC',
    );
    return List.generate(maps.length, (i) => Dose.fromMap(maps[i]));
  }

  @Deprecated(
      'Use DoseScheduleRepository.createDoseSchedulesForMedication instead')
  Future<void> createDosesForMedication(Medication medication) async {
    throw UnimplementedError(
        'Use DoseScheduleRepository.createDoseSchedulesForMedication instead');
  }

  Future<void> deleteDosesForMedication(int medicationId) async {
    await database.delete(
      'dose_schedules',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
  }
}
