import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/data/models/dose.dart';
import 'package:myapp/src/features/medication/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/dose_history_list.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch all doses when the screen is initialized
    Provider.of<DoseProvider>(context, listen: false).loadAllDoses();
    Provider.of<MedicationProvider>(context, listen: false).loadMedications();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // For Taken, Skipped, Pending
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dose History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Taken'),
              Tab(text: 'Skipped'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        body: Consumer<DoseProvider>(
          builder: (context, doseProvider, child) {
            if (doseProvider.doses.isEmpty) {
              return const Center(child: Text('No dose history yet.'));
            }

            final takenDoses = doseProvider.doses
                .where((d) => d.status == DoseStatus.taken)
                .toList();
            final skippedDoses = doseProvider.doses
                .where((d) => d.status == DoseStatus.skipped)
                .toList();
            final pendingDoses = doseProvider.doses
                .where((d) => d.status == DoseStatus.pending)
                .toList();

            return TabBarView(
              children: [
                DoseHistoryList(doses: takenDoses),
                DoseHistoryList(doses: skippedDoses),
                DoseHistoryList(doses: pendingDoses),
              ],
            );
          },
        ),
      ),
    );
  }
}
