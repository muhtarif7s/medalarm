import 'package:equatable/equatable.dart';

enum DoseStatus { pending, taken, skipped }

class Dose extends Equatable {
  final int? id;
  final int medicationId;
  final DateTime time;
  final DoseStatus status;

  const Dose({
    this.id,
    required this.medicationId,
    required this.time,
    required this.status,
  });

  @override
  List<Object?> get props => [id, medicationId, time, status];

  Dose copyWith({
    int? id,
    int? medicationId,
    DateTime? time,
    DoseStatus? status,
  }) {
    return Dose(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'time': time.toIso8601String(),
      'status': status.name,
    };
  }

  static Dose fromMap(Map<String, dynamic> map) {
    return Dose(
      id: map['id'] as int?,
      medicationId: map['medicationId'] as int,
      time: DateTime.parse(map['time'] as String),
      status: DoseStatus.values.byName(map['status'] as String),
    );
  }
}
