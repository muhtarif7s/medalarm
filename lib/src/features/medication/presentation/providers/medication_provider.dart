import \'package:flutter/foundation.dart\';
import \'package:myapp/src/features/doses/data/repositories/dose_repository.dart\';
import \'package:myapp/src/features/medication/data/models/medication.dart\';
import \'package:myapp/src/features/medication/data/repositories/medication_repository.dart\';
import \'package:myapp/src/features/medication/presentation/services/dose_service.dart\';
import \'package:myapp/src/features/medication/presentation/services/notification_service.dart\';
import \'package:shared_preferences/shared_preferences.dart\';

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

  Future<void> init() async {
    // Initialize the database by getting the database instance
    await _medicationRepository.dbHelper.database;
  }

  Future<void> resetMedicationStatusIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString(\'lastReset\');
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
      await prefs.setString(\'lastReset\', today);
    }
  }

  Future<void> loadMedications() async {
    _isLoading = true;
    notifyListeners();
    await resetMedicationStatusIfNeeded();
    _medications = await _medicationRepository.getAllMedications();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMedication(Medication medication) async {
    final id = await _medicationRepository.addMedication(medication);
    final newMedication = medication.copyWith(id: id);
    await _doseService.createDosesForMedication(newMedication);
    await _notificationService.scheduleNotifications(
        newMedication, \'Medication Due: \${newMedication.name}\', \'It\\\'s time to take your dose of \${newMedication.name}.\');
    await loadMedications();
  }

  Future<void> updateMedication(Medication medication) async {
    await _medicationRepository.updateMedication(medication);
    await _doseRepository.deleteDosesForMedication(medication.id!);
    await _doseService.createDosesForMedication(medication);
    await _notificationService.scheduleNotifications(
        medication, \'Medication Due: \${medication.name}\', \'It\\\'s time to take your dose of \${medication.name}.\');
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
