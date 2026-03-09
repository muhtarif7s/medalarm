import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';

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

  Future<void> loadDoses() async {
    _isLoading = true;
    notifyListeners();
    _doses = await _doseScheduleRepository.getAllPendingDoseSchedules();
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

  Future<Medication?> medicationForDose(DoseSchedule dose) async {
    return await _medicationProvider.getMedication(dose.medicationId);
  }
}
