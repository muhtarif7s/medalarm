import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/scheduling_service.dart';

class DoseService {
  final DoseRepository _doseRepository = DoseRepository();
  final SchedulingService _schedulingService = SchedulingService();

  Future<void> createDosesForMedication(Medication medication) async {
    final doses = _schedulingService.calculateUpcomingDoses(medication);
    for (final dose in doses) {
      await _doseRepository.addDose(dose);
    }
  }
}
