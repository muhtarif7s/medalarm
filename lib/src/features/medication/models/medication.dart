// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/medication/models/day_of_week.dart';

enum MedicationScheduleType {
  daily,
  specificDays,
  interval,
}

@immutable
class Medication extends Equatable {
  final int? id;
  final String name;
  final double dosage;
  final String unit;
  final int stock;
  final MedicationScheduleType scheduleType;
  final List<TimeOfDay> times; // A list of times for the doses
  final List<DayOfWeek>? daysOfWeek; // 1=Monday, 7=Sunday
  final int? interval; // In days
  final DateTime startDate;
  final DateTime? endDate;
  final int remainingDoses;
  final int takenToday;
  final List<Dose> doseHistory;

  int get doses => times.length;

  String get frequency =>
      times.isEmpty ? 'No frequency' : '${times.length} times/day';

  const Medication({
    this.id,
    required this.name,
    required this.dosage,
    required this.unit,
    required this.stock,
    required this.scheduleType,
    required this.times,
    this.daysOfWeek,
    this.interval,
    required this.startDate,
    this.endDate,
    required this.remainingDoses,
    this.takenToday = 0,
    this.doseHistory = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        dosage,
        unit,
        stock,
        scheduleType,
        times,
        daysOfWeek,
        interval,
        startDate,
        endDate,
        remainingDoses,
        takenToday,
        doseHistory,
      ];

  Medication copyWith({
    int? id,
    String? name,
    double? dosage,
    String? unit,
    int? stock,
    MedicationScheduleType? scheduleType,
    List<TimeOfDay>? times,
    List<DayOfWeek>? daysOfWeek,
    int? interval,
    DateTime? startDate,
    DateTime? endDate,
    int? remainingDoses,
    int? takenToday,
    List<Dose>? doseHistory,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      scheduleType: scheduleType ?? this.scheduleType,
      times: times ?? this.times,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      remainingDoses: remainingDoses ?? this.remainingDoses,
      takenToday: takenToday ?? this.takenToday,
      doseHistory: doseHistory ?? this.doseHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'unit': unit,
      'stock': stock,
      'scheduleType': scheduleType.name,
      'times': times.map((time) => '${time.hour}:${time.minute}').join(','),
      'daysOfWeek': daysOfWeek?.map((day) => day.index).join(','),
      'interval': interval,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'remainingDoses': remainingDoses,
      // 'takenToday' is not persisted in the current schema.
    };
  }

  static Medication fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] as int?,
      name: map['name'] as String,
      dosage: (map['dosage'] as num).toDouble(),
      unit: map['unit'] as String,
      stock: map['stock'] as int? ?? 0,
      scheduleType: MedicationScheduleType.values.byName(
        map['scheduleType'] as String,
      ),
      times: (map['times'] as String?)
              ?.split(',')
              .where((s) => s.isNotEmpty)
              .map((s) => TimeOfDay(
                    hour: int.parse(s.split(':')[0]),
                    minute: int.parse(s.split(':')[1]),
                  ))
              .toList() ??
          [],
      daysOfWeek: (map['daysOfWeek'] as String?)
          ?.split(',')
          .where((s) => s.isNotEmpty)
          .map((s) => DayOfWeek.values[int.parse(s)])
          .toList(),
      interval: map['interval'] as int?,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
      remainingDoses: map['remainingDoses'] as int? ?? 0,
      takenToday: 0,
    );
  }
}
