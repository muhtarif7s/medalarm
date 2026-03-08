class Medicine {
  final int? id;
  final String name;
  final String? notes;
  final String? iconName;
  final String? color;
  final double dosageAmount;
  final String dosageUnit;
  final double? totalQuantity;
  final double? remainingQuantity;
  final double? refillReminderAt;
  final String frequencyType;
  final String doseTimes;
  final String? specificDays;
  final int? intervalDays;
  final String startDate;
  final String? endDate;
  final int skipCount;
  final String? createdAt;

  Medicine({
    this.id,
    required this.name,
    this.notes,
    this.iconName,
    this.color,
    required this.dosageAmount,
    required this.dosageUnit,
    this.totalQuantity,
    this.remainingQuantity,
    this.refillReminderAt,
    required this.frequencyType,
    required this.doseTimes,
    this.specificDays,
    this.intervalDays,
    required this.startDate,
    this.endDate,
    this.skipCount = 0,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'icon_name': iconName,
      'color': color,
      'dosage_amount': dosageAmount,
      'dosage_unit': dosageUnit,
      'total_quantity': totalQuantity,
      'remaining_quantity': remainingQuantity,
      'refill_reminder_at': refillReminderAt,
      'frequency_type': frequencyType,
      'dose_times': doseTimes,
      'specific_days': specificDays,
      'interval_days': intervalDays,
      'start_date': startDate,
      'end_date': endDate,
      'skip_count': skipCount,
      'created_at': createdAt,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      notes: map['notes'],
      iconName: map['icon_name'],
      color: map['color'],
      dosageAmount: map['dosage_amount'],
      dosageUnit: map['dosage_unit'],
      totalQuantity: map['total_quantity'],
      remainingQuantity: map['remaining_quantity'],
      refillReminderAt: map['refill_reminder_at'],
      frequencyType: map['frequency_type'],
      doseTimes: map['dose_times'],
      specificDays: map['specific_days'],
      intervalDays: map['interval_days'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      skipCount: map['skip_count'],
      createdAt: map['created_at'],
    );
  }
}
