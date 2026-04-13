// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/widgets/medication_list_item.dart';

class MedicationList extends StatelessWidget {
  final List<Medication> medications;

  const MedicationList({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Add this
      physics: const NeverScrollableScrollPhysics(), // And this
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
