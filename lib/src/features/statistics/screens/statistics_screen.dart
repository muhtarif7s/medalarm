
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doseProvider = Provider.of<DoseProvider>(context, listen: false);
      final medicationProvider = Provider.of<MedicationProvider>(context, listen: false);
      doseProvider.loadAllDoses();
      medicationProvider.loadMedications();
    });
  }

  @override
  Widget build(BuildContext context) {
    const darkBackgroundColor = Color(0xFF121212);
    const cardBackgroundColor = Color(0xFF1E1E1E);
    const subtleBorderColor = Colors.white24;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text('Statistics', style: TextStyle(color: Colors.white)),
        backgroundColor: darkBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMonthlyOverviewCard(cardBackgroundColor, subtleBorderColor),
            const SizedBox(height: 20),
            _buildMostSkippedCard(cardBackgroundColor, subtleBorderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyOverviewCard(Color cardColor, Color borderColor) {
    return Consumer<DoseProvider>(
      builder: (context, doseProvider, child) {
        if (doseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final now = DateTime.now();
        final dosesThisMonth = doseProvider.doses
            .where((d) => d.time.month == now.month && d.time.year == now.year)
            .toList();
        final takenDoses = dosesThisMonth.where((d) => d.status == DoseStatus.taken).length;
        final missedDoses = dosesThisMonth.where((d) => d.status == DoseStatus.missed).length;

        return Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Overview',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn('Taken', takenDoses.toString(), Colors.green),
                    _buildStatColumn('Skipped', missedDoses.toString(), Colors.red),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMostSkippedCard(Color cardColor, Color borderColor) {
    return Consumer<DoseProvider>(
      builder: (context, doseProvider, child) {
        final medicationProvider = context.watch<MedicationProvider>();
        if (doseProvider.isLoading || medicationProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final now = DateTime.now();
        final missedDosesThisMonth = doseProvider.doses
            .where((d) => d.time.month == now.month && d.time.year == now.year && d.status == DoseStatus.missed)
            .toList();

        if (missedDosesThisMonth.isEmpty) {
          return Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: borderColor),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No skipped medications this month!',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        }

        final skippedCount = <int, int>{};
        for (final dose in missedDosesThisMonth) {
          skippedCount[dose.medicationId] = (skippedCount[dose.medicationId] ?? 0) + 1;
        }

        final mostSkippedMedicationId =
            skippedCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
        final mostSkippedMedication =
            medicationProvider.getMedication(mostSkippedMedicationId);
        final skipCount = skippedCount[mostSkippedMedicationId];

        return Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Most Skipped',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.medication, color: Colors.red, size: 40),
                  title: Text(
                    mostSkippedMedication?.name ?? 'Unknown Medication',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Skipped $skipCount times this month',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
