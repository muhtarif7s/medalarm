import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/medication_list.dart';
import 'package:myapp/src/shared/widgets/empty_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yourMedications),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/add-edit-medication');
            },
          ),
        ],
      ),
      body: Consumer<MedicationProvider>(
        builder: (context, medicationProvider, child) {
          if (medicationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (medicationProvider.errorMessage != null) {
            return Center(child: Text(medicationProvider.errorMessage!));
          }

          if (medicationProvider.medications.isEmpty) {
            return EmptyState(
              icon: Icons.medical_services_outlined,
              title: l10n.noMedicationsYet,
              message: l10n.addMedicationToGetStarted,
            );
          }

          return MedicationList(medications: medicationProvider.medications);
        },
      ),
    );
  }
}
