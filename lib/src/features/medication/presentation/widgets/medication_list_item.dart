import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';

class MedicationListItem extends StatelessWidget {
  const MedicationListItem({super.key, required this.medication, this.onTap, this.onDelete});

  final Medication medication;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(medication.name),
      subtitle: Text(buildScheduleDescription(context, l10n)),
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditMedicationScreen(medication: medication),
          ),
        );
      },
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            )
          : null,
    );
  }

  String buildScheduleDescription(BuildContext context, AppLocalizations l10n) {
    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        return l10n.dailyDose(medication.times.map((e) => e.format(context)).join(', '));
      case MedicationScheduleType.specificDays:
        return l10n.specificDaysDose(
          medication.daysOfWeek!.map((day) => day.toString().split('.').last).join(', '),
          medication.times.map((e) => e.format(context)).join(', '),
        );
      case MedicationScheduleType.interval:
        return l10n.intervalDose(
          medication.interval.toString(),
          medication.times.map((e) => e.format(context)).join(', '),
        );
    }
  }
}
