import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/presentation/widgets/dose_history_list.dart';

String buildScheduleDescription(
    Medication med, AppLocalizations l10n, BuildContext context) {
  final timeStrings = med.times
      .map((t) => t.format(context))
      .join(', ');

  switch (med.scheduleType) {
    case MedicationScheduleType.daily:
      return l10n.dailyDose(timeStrings);
    case MedicationScheduleType.weekdays:
      final days = med.weekdays ?? [];
      final dayNames = days
          .map((d) =>
              [l10n.monday, l10n.tuesday, l10n.wednesday, l10n.thursday, l10n.friday, l10n.saturday, l10n.sunday][d - 1])
          .join(', ');
      return l10n.onDays(dayNames, timeStrings);
    case MedicationScheduleType.interval:
      return l10n.intervalDose(med.interval.toString(), timeStrings);
  }
}

class MedicationDetailScreen extends StatefulWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  State<MedicationDetailScreen> createState() => _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<DoseProvider>(context, listen: false)
            .loadDosesForMedication(widget.medication.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final doseProvider = Provider.of<DoseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                context.goNamed('editMedication', extra: widget.medication),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(widget.medication, l10n),
            const SizedBox(height: 24),
            Text(l10n.doseHistory,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (doseProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (doseProvider.doses.isEmpty)
              Center(child: Text(l10n.noDoseHistoryAvailable))
            else
              DoseHistoryList(doses: doseProvider.doses),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Medication medication, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                l10n, Icons.medical_services, l10n.medicationDosage(medication.dosage.toString(), medication.unit)),
            const Divider(height: 24),
            _buildScheduleInfo(medication, l10n),
            const Divider(height: 24),
            _buildDateInfo(medication, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleInfo(Medication medication, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(l10n, Icons.schedule, l10n.scheduled, isHeader: true),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 40), // Indent details
          child: Text(buildScheduleDescription(medication, l10n, context)),
        ),
      ],
    );
  }

  Widget _buildDateInfo(Medication medication, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(l10n, Icons.date_range, l10n.duration, isHeader: true),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.startDateLabel(DateFormat.yMMMd().format(medication.startDate))),
              Text(medication.endDate != null
                  ? l10n.endDateLabel(DateFormat.yMMMd().format(medication.endDate!))
                  : l10n.ongoing),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(AppLocalizations l10n, IconData icon, String text, {bool isHeader = false}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 16),
        Text(
          text,
          style: isHeader
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
