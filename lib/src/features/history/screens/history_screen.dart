// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/shared/widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DoseProvider>(context, listen: false).loadAllDoses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<DoseProvider>(
        builder: (context, doseProvider, child) {
          if (doseProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (doseProvider.groupedDosesByDay.isEmpty) {
            return const EmptyState(
              icon: Icons.history,
              title: 'No History',
              message: 'No medication history found.',
            );
          }

          final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);

          return ListView.builder(
            itemCount: doseProvider.groupedDosesByDay.keys.length,
            itemBuilder: (context, index) {
              final date = doseProvider.groupedDosesByDay.keys.elementAt(index);
              final dosesForDay = doseProvider.groupedDosesByDay[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      DateFormat.yMMMMEEEEd().format(date),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...dosesForDay.map((dose) {
                    final medication = medicationProvider.getMedicationById(dose.medicationId.toString());
                    return ListTile(
                      leading: const Icon(Icons.medication),
                      title: Text(medication?.name ?? 'Unknown Medication'),
                      subtitle: Text(DateFormat.jm().format(dose.scheduledTime)),
                      trailing: Text(dose.status.name, style: TextStyle(color: _getStatusColor(dose.status))),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return Colors.green;
      case DoseStatus.missed:
        return Colors.red;
      case DoseStatus.pending:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
