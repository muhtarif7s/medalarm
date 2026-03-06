import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class SchedulingService {
  List<Dose> calculateUpcomingDoses(Medication medication) {
    final now = DateTime.now();
    final upcomingDoses = <Dose>[];

    if (medication.endDate != null && now.isAfter(medication.endDate!)) {
      return upcomingDoses;
    }

    for (final time in medication.times) {
      var scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      if (_isScheduledFor(medication, scheduledTime)) {
        upcomingDoses.add(Dose(
          medicationId: medication.id!,
          scheduledTime: scheduledTime,
        ));
      }
    }

    upcomingDoses.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return upcomingDoses;
  }

  bool _isScheduledFor(Medication medication, DateTime dateTime) {
    if (medication.startDate.isAfter(dateTime)) {
      return false;
    }
    if (medication.endDate != null && medication.endDate!.isBefore(dateTime)) {
      return false;
    }

    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        return true;
      case MedicationScheduleType.weekdays:
        return medication.weekdays?.contains(dateTime.weekday) ?? false;
      case MedicationScheduleType.interval:
        final difference = dateTime.difference(medication.startDate).inHours;
        return difference % medication.interval! == 0;
    }
  }
}
