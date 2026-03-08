class DoseHistory {
  final int? id;
  final int medicineId;
  final String date;
  final int taken;

  DoseHistory({
    this.id,
    required this.medicineId,
    required this.date,
    required this.taken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineId': medicineId,
      'date': date,
      'taken': taken,
    };
  }

  factory DoseHistory.fromMap(Map<String, dynamic> map) {
    return DoseHistory(
      id: map['id'],
      medicineId: map['medicineId'],
      date: map['date'],
      taken: map['taken'],
    );
  }
}
