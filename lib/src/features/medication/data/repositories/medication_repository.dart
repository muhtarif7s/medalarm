// Dart imports:
import 'dart:async';

// Package imports:
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:myapp/src/features/medication/models/medication.dart';

class MedicationRepository {
  final Database database;
  final _medicationsController = StreamController<List<Medication>>.broadcast();

  MedicationRepository({required this.database});

  Stream<List<Medication>> get allMedications => _medicationsController.stream;

  Future<void> fetchAllMedications() async {
    final medications = await _getAllMedicationsFromDb();
    _medicationsController.add(medications);
  }

  Future<int> addMedication(Medication medication) async {
    final id = await database.insert('medications', medication.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await fetchAllMedications();
    return id;
  }

  Future<void> updateMedication(Medication medication) async {
    await database.update('medications', medication.toMap(), where: 'id = ?', whereArgs: [medication.id]);
    await fetchAllMedications();
  }

  Future<void> deleteMedication(int id) async {
    await database.delete('medications', where: 'id = ?', whereArgs: [id]);
    await database.delete('doses', where: 'medicationId = ?', whereArgs: [id]);
    await fetchAllMedications();
  }

  Future<Medication?> getMedication(int id) async {
    final maps = await database.query('medications', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Medication.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Medication>> _getAllMedicationsFromDb() async {
    final maps = await database.query('medications');
    return List.generate(maps.length, (i) {
      return Medication.fromMap(maps[i]);
    });
  }

  Future<List<Medication>> getAllMedicationsOnce() async {
    return await _getAllMedicationsFromDb();
  }
}
