import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/add_medication/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:provider/provider.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailsScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditMedicationScreen(medication: medication),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, medicationProvider),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: ${medication.dosage} ${medication.unit}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Stock: ${medication.stock}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Remaining Doses: ${medication.remainingDoses}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Schedule: ${_formatSchedule(context)}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
                'Duration: ${DateFormat.yMd().format(medication.startDate)} - ${medication.endDate != null ? DateFormat.yMd().format(medication.endDate!) : 'Ongoing'}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  String _formatSchedule(BuildContext context) {
    final timeString = medication.times.map((time) => time.format(context)).join(', ');
    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        return '$timeString daily';
      case MedicationScheduleType.specificDays:
        final daysString = medication.daysOfWeek?.map((day) => day.name.substring(0, 3)).join(', ');
        return '$timeString on $daysString';
      case MedicationScheduleType.interval:
        return '$timeString, every ${medication.interval} days';
    }
  }

  void _confirmDelete(BuildContext context, MedicationProvider medicationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this medication?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                if (medication.id != null) {
                  medicationProvider.removeMedication(medication.id!);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }
}
