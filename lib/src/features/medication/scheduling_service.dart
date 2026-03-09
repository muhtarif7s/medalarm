import 'package:flutter/material.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class SchedulingService {
  List<DateTime> calculateScheduledTimes(Medication medication) {
    final List<DateTime> scheduledTimes = [];
    final now = DateTime.now();
    var currentDate = medication.startDate;

    if (currentDate.isBefore(now)) {
      currentDate = DateTime(now.year, now.month, now.day);
    }

    final endDate = medication.endDate ?? currentDate.add(const Duration(days: 365 * 5)); // Default to 5 years if no end date

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      bool shouldSchedule = false;
      switch (medication.scheduleType) {
        case MedicationScheduleType.daily:
          shouldSchedule = true;
          break;
        case MedicationScheduleType.weekdays:
          if (medication.weekdays != null && medication.weekdays!.contains(currentDate.weekday)) {
            shouldSchedule = true;
          }
          break;
        case MedicationScheduleType.interval:
          if (medication.interval != null) {
            final difference = currentDate.difference(medication.startDate).inDays;
            if (difference % medication.interval! == 0) {
              shouldSchedule = true;
            }
          }
          break;
      }

      if (shouldSchedule) {
        for (final time in medication.times) {
          final scheduledTime = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            time.hour,
            time.minute,
          );
          if (scheduledTime.isAfter(now)) {
            scheduledTimes.add(scheduledTime);
          }
        }
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return scheduledTimes;
  }
}
