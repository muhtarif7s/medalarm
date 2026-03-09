import 'package:myapp/src/features/medication/presentation/services/medication_service.dart';

class DailyResetService {
  final MedicationService _medicationService;

  DailyResetService(this._medicationService);

  Future<void> resetAllMedicationsTakenToday() async {
    final medications = await _medicationService.getAllMedications();
    for (final medication in medications) {
      if (medication.takenToday > 0) {
        final updatedMedication = medication.copyWith(takenToday: 0);
        await _medicationService.updateMedication(updatedMedication);
      }
    }
  }
}
