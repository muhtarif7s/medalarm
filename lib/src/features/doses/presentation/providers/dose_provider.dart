// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:collection/collection.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';

class DoseProvider with ChangeNotifier {
  final DoseScheduleRepository _doseScheduleRepository;
  final MedicationProvider _medicationProvider;

  DoseProvider(this._doseScheduleRepository, this._medicationProvider);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<DoseSchedule> _doses = [];
  List<DoseSchedule> get doses => _doses;

  Map<DateTime, List<DoseSchedule>> get groupedDosesByDay {
    return groupBy(_doses, (dose) => DateTime(dose.scheduledTime.year, dose.scheduledTime.month, dose.scheduledTime.day));
  }

  Future<void> loadAllDoses() async {
    _isLoading = true;
    notifyListeners();
    _doses = await _doseScheduleRepository.getAllDoseSchedules();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDosesForDay(DateTime date) async {
    _isLoading = true;
    notifyListeners();
    _doses = await _doseScheduleRepository.getDoseSchedulesForDay(date);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadDosesForMedication(int medicationId) async {
    _isLoading = true;
    notifyListeners();
    _doses = await _doseScheduleRepository.getDoseSchedulesForMedication(medicationId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> takeDose(DoseSchedule dose) async {
    final updatedDose = dose.copyWith(status: DoseStatus.taken);
    await _doseScheduleRepository.updateDoseSchedule(updatedDose);
    await _medicationProvider.loadMedications();
    await loadDosesForDay(dose.scheduledTime);
  }

  Future<void> updateDoseStatus(DoseSchedule dose, DoseStatus status) async {
    final updatedDose = dose.copyWith(status: status);
    await _doseScheduleRepository.updateDoseSchedule(updatedDose);
    await _medicationProvider.loadMedications();
    await loadDosesForDay(dose.scheduledTime);
  }

  Future<List<DoseSchedule>> getDoseSchedulesForDay(DateTime date) async {
    return await _doseScheduleRepository.getDoseSchedulesForDay(date);
  }

  Future<List<DoseSchedule>> getAllPendingDoseSchedules() async {
    return await _doseScheduleRepository.getAllPendingDoseSchedules();
  }

  Future<void> addDose(Dose dose) async {
    // This seems to be a left-over from a previous implementation. 
    // The Dose model is not used, so this is a no-op.
  }

  Future<Medication?> medicationForDose(DoseSchedule dose) async {
    return await _medicationProvider.getMedication(dose.medicationId);
  }
}
