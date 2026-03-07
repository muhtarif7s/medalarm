import 'package:flutter/material.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:collection/collection.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';

class DoseProvider with ChangeNotifier {
  final DoseRepository _doseRepository = DoseRepository();
  final MedicationRepository _medicationRepository = MedicationRepository();

  List<Dose> _doses = [];
  Map<int, Medication> _medicationMap = {};
  bool _isLoading = false;

  List<Dose> get doses => _doses;
  bool get isLoading => _isLoading;
  Medication? medicationForDose(Dose dose) => _medicationMap[dose.medicationId];

  Map<DateTime, List<Dose>> get groupedDosesByDay {
    return groupBy(_doses, (Dose dose) => DateTime(dose.time.year, dose.time.month, dose.time.day));
  }

  DoseProvider();

  Future<void> loadDoses() async {
    _isLoading = true;
    notifyListeners();
    
    _doses = await _doseRepository.getAllDoses();
    final medications = await _medicationRepository.getAllMedications();
    _medicationMap = { for (var med in medications) med.id! : med };

    _doses.sort((a, b) => b.time.compareTo(a.time));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDosesForMedication(int medicationId) async {
    _isLoading = true;
    notifyListeners();

    _doses = await _doseRepository.getDosesForMedication(medicationId);
    final medication = await _medicationRepository.getMedication(medicationId);
    if (medication != null) {
      _medicationMap = {medication.id!: medication};
    }

    _doses.sort((a, b) => b.time.compareTo(a.time));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateDoseStatus(Dose dose, DoseStatus status) async {
    await _doseRepository.updateDoseStatus(dose.id!, status);
    final index = _doses.indexWhere((d) => d.id == dose.id);
    if (index != -1) {
      _doses[index] = _doses[index].copyWith(status: status);
      notifyListeners();
    }
  }
}
