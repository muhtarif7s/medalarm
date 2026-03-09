import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/database/database_helper.dart';

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Consumer<MedicationProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
            }
            return FutureBuilder<List<DoseSchedule>>(
                future: _getDoseSchedules(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No doses scheduled for today.'));
                  }

                  final todaySchedules = snapshot.data!;

                  todaySchedules.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

                  if (todaySchedules.isEmpty) {
                    return const Center(child: Text('No doses scheduled for today.'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: todaySchedules.map((schedule) {
                        try {
                            final medication = provider.medications.firstWhere(
                                (med) => med.id == schedule.medicationId,
                            );
                            return _buildTimelineItem(context, medication, schedule);
                        } catch (e) {
                            return const SizedBox.shrink();
                        }
                      }).toList(),
                    ),
                  );
                });
          },
        ),
      ],
    );
  }

  Future<List<DoseSchedule>> _getDoseSchedules() async {
      try {
        final db = await DatabaseHelper().database;
        final repository = DoseScheduleRepository(database: db);
        return await repository.getDoseSchedulesForDay(DateTime.now());
      } catch (e) {
        throw Exception('Failed to get dose schedules for today: $e');
      }
  }

  Widget _buildTimelineItem(BuildContext context, Medication medication, DoseSchedule schedule) {
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
        if (schedule.scheduledTime.isBefore(DateTime.now())) {
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
          Text(DateFormat.jm().format(schedule.scheduledTime), style: const TextStyle(fontWeight: FontWeight.bold)),
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
