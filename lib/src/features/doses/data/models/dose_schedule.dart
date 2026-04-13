// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';

class DoseSchedule extends Equatable {
  final int? id;
  final int medicationId;
  final DateTime scheduledTime;
  final DoseStatus status;

  const DoseSchedule({
    this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.status = DoseStatus.pending,
  });

  @override
  List<Object?> get props => [id, medicationId, scheduledTime, status];

  DoseSchedule copyWith({
    int? id,
    int? medicationId,
    DateTime? scheduledTime,
    DoseStatus? status,
  }) {
    return DoseSchedule(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'status': status.name,
    };
  }

  static DoseSchedule fromMap(Map<String, dynamic> map) {
    return DoseSchedule(
      id: map['id'] as int?,
      medicationId: map['medicationId'] as int,
      scheduledTime: DateTime.parse(map['scheduledTime'] as String),
      status: DoseStatus.values.byName(map['status'] as String),
    );
  }
}
