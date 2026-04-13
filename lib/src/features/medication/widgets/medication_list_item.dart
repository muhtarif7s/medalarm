// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/shared/helpers/day_of_week_helper.dart';

class MedicationListItem extends StatelessWidget {
  const MedicationListItem({
    super.key,
    required this.medication,
    this.onTap,
    this.onDelete,
  });

  final Medication medication;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.medication),
        title: Text(medication.name),
        subtitle: Text(buildScheduleDescription(context, l10n)),
        onTap: onTap,
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }

  String buildScheduleDescription(BuildContext context, AppLocalizations l10n) {
    final times = medication.times.map((e) => e.format(context)).join(', ');
    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        return l10n.dailyDose(times);
      case MedicationScheduleType.specificDays:
        final days = medication.daysOfWeek!.map((day) => getLocalizedDayOfWeek(context, day)).join(', ');
        return l10n.specificDaysDose(days, times);
      case MedicationScheduleType.interval:
        return l10n.intervalDose(medication.interval.toString(), times);
    }
  }
}
