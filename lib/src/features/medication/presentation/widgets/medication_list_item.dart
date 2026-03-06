import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class MedicationListItem extends StatelessWidget {
  final Medication medication;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MedicationListItem({
    super.key,
    required this.medication,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildLeadingIcon(context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${medication.dosage} ${medication.unit}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _buildScheduleSummary(context),
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                onPressed: onDelete,
                tooltip: 'Delete Medication',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.medication_outlined,
        size: 30,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  String _buildScheduleSummary(BuildContext context) {
    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        return 'Daily at ${medication.times.map((t) => t.format(context)).join(', ')}';
      case MedicationScheduleType.weekdays:
        final days = medication.weekdays?.map((d) => DateFormat.E().format(DateTime(2023, 1, d))).join(', ') ?? '';
        return 'On $days';
      case MedicationScheduleType.interval:
        return 'Every ${medication.interval} hours';
    }
  }
}
