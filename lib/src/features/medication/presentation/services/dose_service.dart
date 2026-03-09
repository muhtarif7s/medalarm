import 'package:flutter/foundation.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/services/medication_service.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';
import 'package:myapp/src/features/medication/scheduling_service.dart';

class DoseService {
  final DoseRepository _doseRepository;
  final MedicationService _medicationService;
  final DoseScheduleRepository _doseScheduleRepository;
  final NotificationService _notificationService;
  final SchedulingService _schedulingService;

  DoseService(
    this._doseRepository,
    this._medicationService,
    this._doseScheduleRepository,
    this._notificationService,
    this._schedulingService,
  );

  @visibleForTesting
  DoseService.test(
    this._doseRepository,
    this._medicationService,
    this._doseScheduleRepository,
    this._notificationService,
    this._schedulingService,
  );

  Future<void> takeDose(int doseScheduleId, int medicationId) async {
    final medication = await _medicationService.getMedication(medicationId);
    if (medication != null && medication.stock > 0) {
      await _doseScheduleRepository.updateDoseScheduleStatus(
          doseScheduleId, DoseStatus.taken);
      final newStock = medication.stock - 1;
      final newRemainingDoses = medication.remainingDoses - 1;
      final updatedMedication = medication.copyWith(
        stock: newStock,
        remainingDoses: newRemainingDoses,
        takenToday: true, // This might need more complex logic
      );
      await _medicationService.updateMedication(updatedMedication);

      await _doseRepository.addDose(Dose(
        medicationId: medicationId,
        time: DateTime.now(),
        status: DoseStatus.taken,
      ));

      if (newStock <= 5) {
        await _notificationService.showNotification(
          medication.id!,
          'Low Stock',
          'You are running low on ${medication.name}. You have $newStock doses left.',
        );
      }
    }
  }

  Future<void> scheduleDosesForMedication(Medication medication) async {
    final scheduledTimes = _schedulingService.calculateScheduledTimes(medication);
    await _doseScheduleRepository.deleteDoseSchedulesForMedication(medication.id!);

    for (final scheduledTime in scheduledTimes) {
      final doseSchedule = DoseSchedule(
        medicationId: medication.id!,
        scheduledTime: scheduledTime,
      );
      final id = await _doseScheduleRepository.addDoseSchedule(doseSchedule);
      await _notificationService.scheduleNotification(
        id,
        medication.name,
        'Time to take your medication',
        scheduledTime,
      );
    }
  }

  Future<void> markMissedDoses() async {
    final now = DateTime.now();
    final pendingSchedules = await _doseScheduleRepository.getAllPendingDoseSchedules();

    for (final schedule in pendingSchedules) {
      if (schedule.scheduledTime.isBefore(now)) {
        await _doseScheduleRepository.updateDoseScheduleStatus(schedule.id!, DoseStatus.missed);
        final medication = await _medicationService.getMedication(schedule.medicationId);
        if (medication != null) {
          await _notificationService.showNotification(
            schedule.id!,
            'Missed Dose',
            'You missed a dose of ${medication.name}.',
          );
        }
      }
    }
  }
}
