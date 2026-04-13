import 'package:flutter/material.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/models/medication.dart';

class MedicationProvider with ChangeNotifier {
  final MedicationRepository _medicationRepository;
  final DoseScheduleRepository _doseScheduleRepository;

  bool _isLoading = false;
  String? _errorMessage;
  List<Medication> _medications = [];

  MedicationProvider(
    this._medicationRepository,
    this._doseScheduleRepository,
  );

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Medication> get medications => _medications;

  Future<void> loadMedications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _medications = await _medicationRepository.getAllMedicationsOnce();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(Medication medication) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newId = await _medicationRepository.addMedication(medication);
      await _doseScheduleRepository.createDoseSchedulesForMedication(
        medication.copyWith(id: newId),
      );
      await loadMedications();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMedication(Medication medication) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _medicationRepository.updateMedication(medication);
      await _doseScheduleRepository.deleteDoseSchedulesForMedication(medication.id!);
      await _doseScheduleRepository.createDoseSchedulesForMedication(medication);
      await loadMedications();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeMedication(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _medicationRepository.deleteMedication(id);
      await _doseScheduleRepository.deleteDoseSchedulesForMedication(id);
      await loadMedications();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Medication? getMedication(int id) {
    try {
      return _medications.firstWhere((med) => med.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Medication?> getMedicationById(int id) async {
    return getMedication(id);
  }

  Future<void> deleteMedication(int id) async {
    await removeMedication(id);
  }
}
