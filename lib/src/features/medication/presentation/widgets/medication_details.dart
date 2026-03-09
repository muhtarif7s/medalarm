import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class MedicationDetails extends StatelessWidget {
  final Medication medication;

  const MedicationDetails({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dosage: ${medication.dosage} ${medication.unit}'),
          Text('Schedule Type: ${medication.scheduleType.toString().split('.').last}'),
          if (medication.scheduleType == MedicationScheduleType.specificDays)
            Text('Days of Week: ${medication.daysOfWeek?.join(', ')}'),
          if (medication.scheduleType == MedicationScheduleType.interval)
            Text('Interval: Every ${medication.interval} days'),
          Text('Start Date: ${DateFormat.yMd().format(medication.startDate)}'),
          if (medication.endDate != null)
            Text('End Date: ${DateFormat.yMd().format(medication.endDate!)}'),
        ],
      ),
    );
  }
}
