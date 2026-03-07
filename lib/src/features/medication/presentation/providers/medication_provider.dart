import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/services/dose_service.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';

class MedicationProvider with ChangeNotifier {
  final MedicationRepository _medicationRepository;
  final DoseRepository _doseRepository;
  final DoseService _doseService;
  final NotificationService _notificationService;

  List<Medication> _medications = [];
  bool _isLoading = false;

  List<Medication> get medications => _medications;
  bool get isLoading => _isLoading;

  MedicationProvider({
    MedicationRepository? medicationRepository,
    DoseRepository? doseRepository,
    DoseService? doseService,
    NotificationService? notificationService,
  })  : _medicationRepository = medicationRepository ?? MedicationRepository(),
        _doseRepository = doseRepository ?? DoseRepository(),
        _doseService = doseService ?? DoseService(),
        _notificationService = notificationService ?? NotificationService();

  Future<void> loadMedications() async {
    _isLoading = true;
    notifyListeners();
    _medications = await _medicationRepository.getAllMedications();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMedication(Medication medication) async {
    final id = await _medicationRepository.addMedication(medication);
    final newMedication = medication.copyWith(id: id);
    await _doseService.createDosesForMedication(newMedication);
    await _notificationService.scheduleNotifications(
        newMedication, 'Medication Due: ${newMedication.name}', 'It\'s time to take your dose of ${newMedication.name}.');
    await loadMedications();
  }

  Future<void> updateMedication(Medication medication) async {
    await _medicationRepository.updateMedication(medication);
    await _doseRepository.deleteDosesForMedication(medication.id!);
    await _doseService.createDosesForMedication(medication);
    await _notificationService.scheduleNotifications(
        medication, 'Medication Due: ${medication.name}', 'It\'s time to take your dose of ${medication.name}.');
    await loadMedications();
  }

  Future<void> deleteMedication(int id) async {
    await _medicationRepository.deleteMedication(id);
    await _notificationService.cancelNotifications(id);
    await loadMedications();
  }

  Future<Medication?> getMedication(int id) async {
    return await _medicationRepository.getMedication(id);
  }
}
