import 'package:flutter/material.dart';
import 'package:myapp/src/features/medication/data/models/dose.dart';
import 'package:myapp/src/features/medication/data/database_helper.dart';

class DoseProvider with ChangeNotifier {
  List<Dose> _doses = [];

  List<Dose> get doses => _doses;

  Future<void> loadDosesForMedication(int medicationId) async {
    try {
      _doses = await DatabaseHelper.instance.getDoses(medicationId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading doses for medication: $e');
    }
  }

  Future<void> loadAllDoses() async {
    try {
      _doses = await DatabaseHelper.instance.getAllDoses();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading all doses: $e');
    }
  }

  Future<void> addDose(Dose dose) async {
    try {
      await DatabaseHelper.instance.insertDose(dose);
      await loadDosesForMedication(dose.medicationId);
    } catch (e) {
      debugPrint('Error adding dose: $e');
    }
  }

  Future<void> updateDose(Dose dose) async {
    try {
      await DatabaseHelper.instance.updateDose(dose);
      await loadDosesForMedication(dose.medicationId);
    } catch (e) {
      debugPrint('Error updating dose: $e');
    }
  }

  Future<void> deleteDose(Dose dose) async {
    try {
      await DatabaseHelper.instance.deleteDose(dose.id!);
      await loadDosesForMedication(dose.medicationId);
    } catch (e) {
      debugPrint('Error deleting dose: $e');
    }
  }
}
