import 'package:flutter/material.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/database_helper.dart';

class MedicationProvider with ChangeNotifier {
  List<Medication> _medications = [];

  List<Medication> get medications => _medications;

  Future<void> loadMedications() async {
    try {
      _medications = await DatabaseHelper.instance.getMedications();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading medications: $e');
    }
  }

  Future<void> addMedication(Medication medication) async {
    try {
      await DatabaseHelper.instance.insertMedication(medication);
      await loadMedications();
    } catch (e) {
      debugPrint('Error adding medication: $e');
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      await DatabaseHelper.instance.updateMedication(medication);
      await loadMedications();
    } catch (e) {
      debugPrint('Error updating medication: $e');
    }
  }

  Future<void> deleteMedication(int id) async {
    try {
      await DatabaseHelper.instance.deleteMedication(id);
      await loadMedications();
    } catch (e) {
      debugPrint('Error deleting medication: $e');
    }
  }
}
