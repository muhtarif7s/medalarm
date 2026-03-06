enum DoseStatus {
  upcoming,
  taken,
  skipped,
  missed,
}

class Dose {
  final int? id;
  final int medicationId;
  final DateTime scheduledTime;
  final DoseStatus status;
  final DateTime? actionTime;

  Dose({
    this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.status = DoseStatus.upcoming,
    this.actionTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'scheduledTime': scheduledTime.toIso8601String(),
      'status': status.index,
      'actionTime': actionTime?.toIso8601String(),
    };
  }

  static Dose fromMap(Map<String, dynamic> map) {
    return Dose(
      id: map['id'],
      medicationId: map['medicationId'],
      scheduledTime: DateTime.parse(map['scheduledTime']),
      status: DoseStatus.values[map['status']],
      actionTime: map['actionTime'] != null ? DateTime.parse(map['actionTime']) : null,
    );
  }
}
