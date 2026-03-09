import 'package:flutter/material.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/medication_details.dart';
import 'package:myapp/src/shared/widgets/empty_state.dart';
import 'package:provider/provider.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final String medicationId;

  const MedicationDetailsScreen({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
      ),
      body: Consumer<MedicationProvider>(
        builder: (context, medicationProvider, child) {
          if (medicationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (medicationProvider.errorMessage != null) {
            return Center(child: Text(medicationProvider.errorMessage!));
          }

          final medication = medicationProvider.getMedicationById(medicationId);

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
