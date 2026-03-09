import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:provider/provider.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final String medicationId;

  const MedicationDetailsScreen({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    final medication = context.watch<MedicationProvider>().getMedicationById(medicationId);

    if (medication == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Medication not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
      ),
      body: Padding(
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
      ),
    );
  }
}
