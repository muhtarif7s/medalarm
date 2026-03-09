import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:collection/collection.dart'; // For groupBy

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<DoseProvider>(context, listen: false).loadDoses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final doseProvider = Provider.of<DoseProvider>(context);

    final groupedDoses = doseProvider.groupedDosesByDay;
    final sortedDates = groupedDoses.keys.sorted((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyScreenTitle),
      ),
      body: doseProvider.isLoading && groupedDoses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : groupedDoses.isEmpty
              ? Center(child: Text(l10n.noDoseHistoryAvailable))
              : ListView.builder(
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final doses = groupedDoses[date]!;
                    return ExpansionTile(
                      title: Text(DateFormat.yMMMMd(l10n.localeName).format(date)),
                      initiallyExpanded: true,
                      children: doses.map((dose) => _buildDoseItem(context, dose, l10n)).toList(),
                    );
                  },
                ),
    );
  }

  Widget _buildDoseItem(
      BuildContext context, DoseSchedule dose, AppLocalizations l10n) {
    final doseProvider = Provider.of<DoseProvider>(context, listen: false);

    return FutureBuilder<Medication?>(
      future: doseProvider.medicationForDose(dose),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final medication = snapshot.data!;
        return ListTile(
          leading: _buildStatusIcon(dose.status),
          title: Text(medication.name),
          subtitle: Text(l10n.doseAt(DateFormat.jm(l10n.localeName).format(dose.scheduledTime))),
          trailing: Text(l10n.doseDetails(medication.dosage.toString(), medication.unit)),
          onTap: () => _showDoseActions(context, dose, l10n),
        );
      },
    );
  }

  Widget _buildStatusIcon(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return const Icon(Icons.check_circle, color: Colors.green, size: 36);
      case DoseStatus.skipped:
        return const Icon(Icons.cancel, color: Colors.red, size: 36);
      case DoseStatus.pending:
        return const Icon(Icons.hourglass_empty, color: Colors.grey, size: 36);
      case DoseStatus.missed:
        return const Icon(Icons.warning, color: Colors.orange, size: 36);
    }
  }

  void _showDoseActions(
      BuildContext context, DoseSchedule dose, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            if (dose.status == DoseStatus.pending || dose.status == DoseStatus.missed)
              ListTile(
                leading: const Icon(Icons.check),
                title: Text(l10n.markAsTaken),
                onTap: () {
                  Provider.of<DoseProvider>(context, listen: false)
                      .updateDoseStatus(dose, DoseStatus.taken);
                  Navigator.pop(context);
                },
              ),
            if (dose.status == DoseStatus.pending || dose.status == DoseStatus.missed)
              ListTile(
                leading: const Icon(Icons.skip_next),
                title: Text(l10n.markAsSkipped),
                onTap: () {
                  Provider.of<DoseProvider>(context, listen: false)
                      .updateDoseStatus(dose, DoseStatus.skipped);
                  Navigator.pop(context);
                },
              ),
            if (dose.status != DoseStatus.pending)
              ListTile(
                leading: const Icon(Icons.undo),
                title: Text(l10n.markAsPending),
                onTap: () {
                  Provider.of<DoseProvider>(context, listen: false)
                      .updateDoseStatus(dose, DoseStatus.pending);
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }
}
