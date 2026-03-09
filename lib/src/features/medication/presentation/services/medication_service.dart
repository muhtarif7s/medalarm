import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/services/dose_service.dart';

class MedicationService {
  final MedicationRepository _medicationRepository;
  final DoseService _doseService;
  final DoseScheduleRepository _doseScheduleRepository;

  MedicationService(
    this._medicationRepository,
    this._doseService,
    this._doseScheduleRepository,
  );

  Future<void> addMedication(Medication medication) async {
    final newMedicationId = await _medicationRepository.addMedication(medication);
    final newMedication = medication.copyWith(id: newMedicationId);
    await _doseService.scheduleDosesForMedication(newMedication);
  }

  Future<void> updateMedication(Medication medication) async {
    await _medicationRepository.updateMedication(medication);
    await _doseService.scheduleDosesForMedication(medication);
  }

  Future<void> deleteMedication(int medicationId) async {
    await _medicationRepository.deleteMedication(medicationId);
    await _doseScheduleRepository.deleteDoseSchedulesForMedication(medicationId);
  }

  Future<List<Medication>> getAllMedications() async {
    return await _medicationRepository.getAllMedications();
  }

  Future<Medication?> getMedication(int id) async {
    return await _medicationRepository.getMedication(id);
  }
}
