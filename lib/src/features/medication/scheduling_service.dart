import 'dart:async';

import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/services/database_service.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/medication/data/models/day_of_week.dart';

class SchedulingService {
  final DatabaseService _dbService = SqfliteDatabaseService();

  Future<void> scheduleDosesForMedication(Medication medication) async {
    final now = DateTime.now();
    if (medication.endDate != null && medication.endDate!.isBefore(now)) {
      return;
    }

    final List<DateTime> scheduledTimes = [];

    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        for (final time in medication.times) {
          final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
          if (scheduledTime.isAfter(now)) {
            scheduledTimes.add(scheduledTime);
          }
        }
        break;
      case MedicationScheduleType.specificDays:
        if (medication.daysOfWeek!.contains(DayOfWeek.values[now.weekday - 1])) {
          for (final time in medication.times) {
            final scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
            if (scheduledTime.isAfter(now)) {
              scheduledTimes.add(scheduledTime);
            }
          }
        }
        break;
      case MedicationScheduleType.interval:
        // Implement interval scheduling logic here
        break;
    }

    for (final scheduledTime in scheduledTimes) {
      final dose = Dose(
        medicationId: medication.id!,
        time: scheduledTime,
        status: DoseStatus.pending,
      );
      await _dbService.insertDose(dose);
    }
  }
}
