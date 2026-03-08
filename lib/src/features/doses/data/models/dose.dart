
enum DoseStatus { taken, skipped, pending }

class Dose {
  final int? id;
  final int medicationId;
  final DateTime time;
  final DoseStatus status;

  Dose({
    this.id,
    required this.medicationId,
    required this.time,
    this.status = DoseStatus.pending,
  });

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
      'status': status.toString(),
    };
  }

  factory Dose.fromMap(Map<String, dynamic> map) {
    return Dose(
      id: map['id'],
      medicationId: map['medicationId'],
      time: DateTime.parse(map['time']),
      status: DoseStatus.values.firstWhere((e) => e.toString() == map['status']),
    );
  }
}
