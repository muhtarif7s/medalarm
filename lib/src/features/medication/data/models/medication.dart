import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum MedicationScheduleType {
  daily,
  weekdays,
  interval,
}

class Medication extends Equatable {
  final int? id;
  final String name;
  final double dosage;
  final String unit;
  final MedicationScheduleType scheduleType;
  final List<TimeOfDay> times;
  final List<int>? weekdays; // 1=Monday, 7=Sunday
  final int? interval; // Every X hours
  final DateTime startDate;
  final DateTime? endDate;

  const Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.scheduleType,
    required this.times,
    this.weekdays,
    this.interval,
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        dosage,
        unit,
        scheduleType,
        times,
        weekdays,
        interval,
        startDate,
        endDate,
      ];

  Medication copyWith({
    int? id,
    String? name,
    double? dosage,
    String? unit,
    MedicationScheduleType? scheduleType,
    List<TimeOfDay>? times,
    List<int>? weekdays,
    int? interval,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      unit: unit ?? this.unit,
      scheduleType: scheduleType ?? this.scheduleType,
      times: times ?? this.times,
      weekdays: weekdays ?? this.weekdays,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'unit': unit,
      'scheduleType': scheduleType.name,
      'times':
          times.map((time) => '${time.hour}:${time.minute}').join(','),
      'weekdays': weekdays?.join(','),
      'interval': interval,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      name: map['name'] as String,
      dosage: (map['dosage'] as num).toDouble(),
      unit: map['unit'] as String,
      scheduleType: MedicationScheduleType.values.byName(
        map['scheduleType'] as String,
      ),
      times: (map['times'] as String)
          .split(',')
          .where((s) => s.isNotEmpty)
          .map((timeStr) {
        final parts = timeStr.split(':');
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }).toList(),
      weekdays: (map['weekdays'] as String?)
          ?.split(',')
          .where((s) => s.isNotEmpty)
          .map(int.parse)
          .toList(),
      interval: map['interval'] as int?,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
    );
  }
}
