import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationProvider with ChangeNotifier {
  final MedicationRepository _medicationRepository;
  final DoseScheduleRepository _doseScheduleRepository;

  List<Medication> _medications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MedicationProvider(this._medicationRepository, this._doseScheduleRepository);

  Future<void> resetMedicationStatusIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastReset = prefs.getString('lastReset');
      final today = DateTime.now().toIso8601String().substring(0, 10);

      if (lastReset != today) {
        final medications = await _medicationRepository.getAllMedications();
        for (final medication in medications) {
          final updatedMedication = medication.copyWith(
            takenToday: 0,
            remainingDoses: medication.doses,
          );
          await _medicationRepository.updateMedication(updatedMedication);
        }
        await prefs.setString('lastReset', today);
      }
    } catch (e) {
      _errorMessage = 'Failed to reset medication status: $e';
    }
  }

  Future<void> loadMedications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await resetMedicationStatusIfNeeded();
      _medications = await _medicationRepository.getAllMedications();
      await _updateRemainingDoses();
    } catch (e) {
      _errorMessage = 'Failed to load medications: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication(Medication medication) async {
    try {
      await _medicationRepository.addMedication(medication);
      await loadMedications();
    } catch (e) {
      _errorMessage = 'Failed to add medication: $e';
      notifyListeners();
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      await _medicationRepository.updateMedication(medication);
      await loadMedications();
    } catch (e) {
      _errorMessage = 'Failed to update medication: $e';
      notifyListeners();
    }
  }

  Future<void> deleteMedication(int id) async {
    try {
      await _medicationRepository.deleteMedication(id);
      await loadMedications();
    } catch (e) {
      _errorMessage = 'Failed to delete medication: $e';
      notifyListeners();
    }
  }

  Future<Medication?> getMedication(int id) async {
    try {
      return await _medicationRepository.getMedication(id);
    } catch (e) {
      _errorMessage = 'Failed to get medication: $e';
      notifyListeners();
      return null;
    }
  }

  Future<void> _updateRemainingDoses() async {
    try {
      for (var i = 0; i < _medications.length; i++) {
        final medication = _medications[i];
        if (medication.id != null) {
          final doseSchedules = await _doseScheduleRepository.getDoseSchedulesForMedication(medication.id!);
          final takenDoses = doseSchedules
              .where((dose) => dose.status == DoseStatus.taken)
              .length;
          final remainingDoses = medication.stock - takenDoses;
          _medications[i] = medication.copyWith(remainingDoses: remainingDoses);
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to update remaining doses: $e';
    }
    notifyListeners();
  }
}
