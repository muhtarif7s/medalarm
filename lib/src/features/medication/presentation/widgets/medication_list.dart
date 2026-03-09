import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/medication_list_item.dart';
import 'package:provider/provider.dart';

class MedicationList extends StatelessWidget {
  final List<Medication> medications;

  const MedicationList({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: medications.length,
      itemBuilder: (context, index) {
        final medication = medications[index];
        return MedicationListItem(
          medication: medication,
          onTap: () {
            context.go('/medication-details/${medication.id}');
          },
          onDelete: () {
            context.read<MedicationProvider>().deleteMedication(medication.id!);
          },
        );
      },
    );
  }
}
