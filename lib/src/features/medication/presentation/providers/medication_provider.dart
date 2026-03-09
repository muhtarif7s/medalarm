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

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;

  MedicationProvider(this._medicationRepository, this._doseScheduleRepository);

  Future<void> resetMedicationStatusIfNeeded() async {
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
  }

  Future<void> loadMedications() async {
    _isLoading = true;
    notifyListeners();
    await resetMedicationStatusIfNeeded();
    _medications = await _medicationRepository.getAllMedications();
    await _updateRemainingDoses();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMedication(Medication medication) async {
    await _medicationRepository.addMedication(medication);
    await loadMedications();
  }

  Future<void> updateMedication(Medication medication) async {
    await _medicationRepository.updateMedication(medication);
    await loadMedications();
  }

  Future<void> deleteMedication(int id) async {
    await _medicationRepository.deleteMedication(id);
    await loadMedications();
  }

  Future<Medication?> getMedication(int id) async {
    return await _medicationRepository.getMedication(id);
  }

  Future<void> _updateRemainingDoses() async {
    for (var i = 0; i < _medications.length; i++) {
      final medication = _medications[i];
      final doseSchedules =
          await _doseScheduleRepository.getDoseSchedulesForMedication(medication.id!);
      final takenDoses = doseSchedules
          .where((dose) => dose.status == DoseStatus.taken)
          .length;
      final remainingDoses = medication.stock - takenDoses;
      _medications[i] = medication.copyWith(remainingDoses: remainingDoses);
    }
    notifyListeners();
  }
}
