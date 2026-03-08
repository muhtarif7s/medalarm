class Medicine {
  final int? id;
  final String name;
  final double dosage;
  final String frequency;
  final double stock;
  final int takenToday;
  final int remainingDoses;
  final String? scheduledTime;
  final bool isCompleted;
  final String startDate;
  final String? endDate;
  final String? notes;

  Medicine({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.stock,
    this.takenToday = 0,
    this.remainingDoses = 0,
    this.scheduledTime,
    this.isCompleted = false,
    required this.startDate,
    this.endDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'stock': stock,
      'taken_today': takenToday,
      'remaining_doses': remainingDoses,
      'scheduled_time': scheduledTime,
      'is_completed': isCompleted ? 1 : 0,
      'startDate': startDate,
      'endDate': endDate,
      'notes': notes,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      frequency: map['frequency'],
      stock: map['stock'],
      takenToday: map['taken_today'],
      remainingDoses: map['remaining_doses'],
      scheduledTime: map['scheduled_time'],
      isCompleted: map['is_completed'] == 1,
      startDate: map['startDate'],
      endDate: map['endDate'],
      notes: map['notes'],
    );
  }
}
