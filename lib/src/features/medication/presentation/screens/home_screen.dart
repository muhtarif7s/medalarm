import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/medication_list_item.dart';
import 'package:myapp/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicationProvider>(context, listen: false).loadMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helloWorld),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Consumer<MedicationProvider>(
        builder: (context, provider, child) {
          if (provider.medications.isEmpty) {
            return _buildEmptyState(context, l10n);
          }
          return _buildMedicationList(provider);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/add_medication'),
        label: Text(l10n.addMedication),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medical_services_outlined, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            l10n.noMedicationsYet,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.addMedicationToGetStarted,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationList(MedicationProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80), // Space for FAB
      itemCount: provider.medications.length,
      itemBuilder: (context, index) {
        final medication = provider.medications[index];
        return MedicationListItem(
          medication: medication,
          onTap: () => context.go('/edit_medication', extra: medication),
          onDelete: () => _confirmDelete(context, medication.id!),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, int medicationId) async {
    final provider = Provider.of<MedicationProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.confirmDelete),
          content: Text(l10n.areYouSureYouWantToDeleteThisMedication),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      provider.deleteMedication(medicationId);
    }
  }
}
