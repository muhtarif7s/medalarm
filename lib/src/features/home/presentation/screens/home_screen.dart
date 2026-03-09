import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/medication_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medicationProvider = context.watch<MedicationProvider>();

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
      body: medicationProvider.medications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.medical_services_outlined, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(l10n.noMedicationsYet, style: Theme.of(context).textTheme.headlineSmall),
                  Text(l10n.addMedicationToGetStarted, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            )
          : MedicationList(medications: medicationProvider.medications),
    );
  }
}
