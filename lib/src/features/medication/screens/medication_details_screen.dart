// Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/medication/providers/medication_provider.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final String medicationId;

  const MedicationDetailsScreen({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, child) {
        final medication = provider.getMedication(int.parse(medicationId));
        return Scaffold(
          appBar: AppBar(
            title: Text(medication?.name ?? 'Medication Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirmed = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Medication'),
                      content:
                          const Text('Are you sure you want to delete this medication?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  if (confirmed) {
                    await provider.removeMedication(int.parse(medicationId));
                    // ignore: use_build_context_synchronously
                    context.pop();
                  }
                },
              ),
            ],
          ),
          body: medication == null
              ? const Center(child: Text('Medication not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Dosage: ${medication.dosage} ${medication.unit}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Frequency: ${medication.frequency}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.push('/edit-medication/$medicationId', extra: medication);
            },
            child: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
