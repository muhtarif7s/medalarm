import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/database/database_helper.dart';

class HistoryList extends StatelessWidget {
  final String filter;

  const HistoryList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        if (provider.medications.isEmpty) {
          return const Center(child: Text('No medications found.'));
        }

        return FutureBuilder<List<DoseSchedule>>(
          future: _getDoseSchedules(provider.medications),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No dose history found.'));
            }

            final doseSchedules = snapshot.data!;
            final medications = provider.medications;

            final items = <Map<String, dynamic>>[];
            for (var schedule in doseSchedules) {
              bool include = false;
              final status = schedule.status;
              final filterLower = filter.toLowerCase();

              if (filterLower == 'all') {
                include = true;
              } else if (filterLower == 'taken' && status == DoseStatus.taken) {
                include = true;
              } else if (filterLower == 'skipped' && status == DoseStatus.skipped) {
                include = true;
              } else if (filterLower == 'upcoming' && status == DoseStatus.pending) {
                include = true;
              }

              if (include) {
                try {
                  final medication = medications.firstWhere(
                    (med) => med.id == schedule.medicationId,
                  );
                  items.add({'medication': medication, 'schedule': schedule});
                } catch (e) {
                  // Medication not found, skip this schedule
                }
              }
            }

            items.sort((a, b) => (b['schedule'].scheduledTime as DateTime).compareTo(a['schedule'].scheduledTime as DateTime));

            if (items.isEmpty) {
              return Center(child: Text('No ${filter.toLowerCase()} doses found.'));
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final Medication medication = item['medication'];
                final DoseSchedule schedule = item['schedule'];

                IconData icon;
                Color color;
                String statusText;

                switch (schedule.status) {
                  case DoseStatus.taken:
                    icon = Icons.check_circle;
                    color = Colors.green;
                    statusText = 'Taken';
                    break;
                  case DoseStatus.skipped:
                    icon = Icons.cancel;
                    color = Colors.red;
                    statusText = 'Skipped';
                    break;
                  case DoseStatus.pending:
                  default:
                    if (schedule.scheduledTime.isBefore(DateTime.now())) {
                        statusText = 'Missed';
                        color = Colors.orange;
                        icon = Icons.warning;
                    } else {
                        statusText = 'Upcoming';
                        color = Colors.grey;
                        icon = Icons.hourglass_bottom;
                    }
                    break;
                }

                final subtitle = '$statusText at ${DateFormat.jm().format(schedule.scheduledTime)}';

                return ListTile(
                  leading: Icon(icon, color: color),
                  title: Text(medication.name),
                  subtitle: Text(subtitle),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<DoseSchedule>> _getDoseSchedules(List<Medication> medications) async {
    try {
      final db = await DatabaseHelper().database;
      final repository = DoseScheduleRepository(database: db);
      final schedules = <DoseSchedule>[];
      for(final medication in medications) {
        if (medication.id != null) {
          final medicationSchedules = await repository.getDoseSchedulesForMedication(medication.id!);
          schedules.addAll(medicationSchedules);
        }
      }
      return schedules;
    } catch (e) {
      throw Exception('Failed to get dose schedules: $e');
    }
  }
}
