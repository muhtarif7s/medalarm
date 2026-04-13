// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/shared/helpers/day_of_week_helper.dart';
import 'package:myapp/src/shared/widgets/card_container.dart';

class MedicationDetails extends StatelessWidget {
  final Medication medication;

  const MedicationDetails({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              GoRouter.of(context).push('/add-medicine', extra: medication.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem(context, Icons.medical_services, l10n.dosage, '${medication.dosage} ${medication.unit}'),
                  _buildDetailItem(context, Icons.inventory, l10n.stock, '${medication.remainingDoses}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem(context, Icons.schedule, l10n.schedule, _buildScheduleText(context, l10n)),
                  _buildDetailItem(context, Icons.calendar_today, l10n.startDate, DateFormat.yMd().format(medication.startDate)),
                  if (medication.endDate != null)
                    _buildDetailItem(context, Icons.calendar_today, l10n.endDate, DateFormat.yMd().format(medication.endDate!)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }

  String _buildScheduleText(BuildContext context, AppLocalizations l10n) {
    final times = medication.times.map((time) => time.format(context)).join(', ');
    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        return '${l10n.daily} at $times';
      case MedicationScheduleType.specificDays:
        final days = medication.daysOfWeek!.map((day) => getLocalizedDayOfWeek(context, day)).join(', ');
        return '${l10n.on} $days at $times';
      case MedicationScheduleType.interval:
        return '${l10n.every} ${medication.interval} ${l10n.hours} at $times';
    }
  }
}
