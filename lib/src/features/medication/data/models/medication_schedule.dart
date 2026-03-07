import 'package:flutter/material.dart';

enum MedicationScheduleType {
  oneTime,
  daily,
  weekdays,
  interval,
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class MedicationSchedule {
  final MedicationScheduleType type;
  final List<TimeOfDay> times;
  final int? interval;
  final List<DayOfWeek>? weekdays;

  MedicationSchedule({
    required this.type,
    required this.times,
    this.interval,
    this.weekdays,
  });
}
