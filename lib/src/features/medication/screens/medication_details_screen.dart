// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/widgets/medication_details.dart';
import 'package:myapp/src/shared/widgets/empty_state.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final String medicationId;

  const MedicationDetailsScreen({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
      ),
      body: FutureBuilder<Medication?>(
        future: Provider.of<MedicationProvider>(context, listen: false).getMedication(int.parse(medicationId)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final medication = snapshot.data;

          if (medication == null) {
            return const EmptyState(
              icon: Icons.error_outline,
              title: 'Medication not found',
              message: 'The requested medication could not be found.',
            );
          }

          return MedicationDetails(medication: medication);
        },
      ),
    );
  }
}
