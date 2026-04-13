// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Consumer2<MedicationProvider, DoseProvider>(
          builder: (context, medicationProvider, doseProvider, child) {
            if (medicationProvider.isLoading || doseProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (medicationProvider.errorMessage != null) {
              return Center(child: Text(medicationProvider.errorMessage!));
            }

            final todaySchedules = doseProvider.doses;

            if (todaySchedules.isEmpty) {
              return const Center(
                  child: Text('No doses scheduled for today.'));
            }

            todaySchedules.sort((a, b) => a.time.compareTo(b.time));

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: todaySchedules.map((schedule) {
                  try {
                    final medication = medicationProvider.medications.firstWhere(
                      (med) => med.id == schedule.medicationId,
                    );
                    return _buildTimelineItem(context, medication, schedule);
                  } catch (e) {
                    return const SizedBox.shrink();
                  }
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
      BuildContext context, Medication medication, Dose schedule) {
    IconData icon;
    Color color;
    String statusTooltip;

    switch (schedule.status) {
      case DoseStatus.taken:
        icon = Icons.check_circle;
        color = Colors.green;
        statusTooltip = 'Taken';
        break;
      case DoseStatus.skipped:
        icon = Icons.cancel;
        color = Colors.red;
        statusTooltip = 'Skipped';
        break;
      case DoseStatus.pending:
      default:
        if (schedule.time.isBefore(DateTime.now())) {
          icon = Icons.error; // Missed
          color = Colors.red;
          statusTooltip = 'Missed';
        } else {
          icon = Icons.hourglass_bottom; // Upcoming
          color = Colors.grey;
          statusTooltip = 'Upcoming';
        }
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(DateFormat.jm().format(schedule.time),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Tooltip(
            message: statusTooltip,
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(medication.name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
