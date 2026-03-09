import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';
import 'package:myapp/src/features/medication/scheduling_service.dart';

class DoseService {
  DoseService(
    DoseScheduleRepository doseScheduleRepository,
    SchedulingService schedulingService,
    NotificationService notificationService,
    MedicationRepository medicationRepository,
  );

  Future<void> checkMissedDoses() async {
    // Implementation will be added later if needed.
  }

  Future<void> scheduleDosesForMedication(Medication medication) async {
    // Implementation will be added later if needed.
  }

  Future<void> deleteDosesForMedication(int medicationId) async {
    // Implementation will be added later if needed.
  }
}
