import 'package:myapp/src/features/medication/presentation/services/medication_service.dart';

class DailyResetService {
  final MedicationService _medicationService;

  DailyResetService(this._medicationService);

  Future<void> resetAllMedicationsTakenToday() async {
    final medications = await _medicationService.getAllMedications();
    for (final medication in medications) {
      if (medication.takenToday) {
        final updatedMedication = medication.copyWith(takenToday: false);
        await _medicationService.updateMedication(updatedMedication);
      }
    }
  }
}
