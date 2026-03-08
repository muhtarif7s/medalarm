class DoseHistory {
  final int? id;
  final int medicineId;
  final String scheduledTime;
  final String? takenAt;
  final String status;

  DoseHistory({
    this.id,
    required this.medicineId,
    required this.scheduledTime,
    this.takenAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicine_id': medicineId,
      'scheduled_time': scheduledTime,
      'taken_at': takenAt,
      'status': status,
    };
  }

  factory DoseHistory.fromMap(Map<String, dynamic> map) {
    return DoseHistory(
      id: map['id'],
      medicineId: map['medicine_id'],
      scheduledTime: map['scheduled_time'],
      takenAt: map['taken_at'],
      status: map['status'],
    );
  }
}
