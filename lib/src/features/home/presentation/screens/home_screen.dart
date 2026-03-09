import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/medication/presentation/widgets/medication_list_item.dart';
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditMedicationScreen(),
                ),
              );
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
          : ListView.builder(
              itemCount: medicationProvider.medications.length,
              itemBuilder: (context, index) {
                final medication = medicationProvider.medications[index];
                return MedicationListItem(
                  medication: medication,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddEditMedicationScreen(medication: medication),
                      ),
                    );
                  },
                  onDelete: () {
                    context
                        .read<MedicationProvider>()
                        .deleteMedication(medication.id!);
                  },
                );
              },
            ),
    );
  }
}
