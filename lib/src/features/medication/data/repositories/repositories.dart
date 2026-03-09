import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';

class Repositories {
  final MedicationRepository medicationRepository;
  final DoseScheduleRepository doseScheduleRepository;

  Repositories(this.medicationRepository, this.doseScheduleRepository);
}
