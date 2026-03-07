import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doseProvider = Provider.of<DoseProvider>(context);
    final groupedDoses = doseProvider.groupedDosesByDay;
    final sortedDates = groupedDoses.keys.toList()..sort((a, b) => b.compareTo(a));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicationHistory),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
      ),
      body: doseProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupedDoses.isEmpty
              ? Center(child: Text(l10n.noDoseHistoryYet))
              : ListView.builder(
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final doses = groupedDoses[date]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _getFormattedDate(date, l10n),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        ...doses.map((dose) => _buildDoseItem(context, dose, l10n)),
                      ],
                    );
                  },
                ),
    );
  }

  String _getFormattedDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date == today) {
      return l10n.today;
    } else if (date == yesterday) {
      return l10n.yesterday;
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }

  Widget _buildDoseItem(BuildContext context, Dose dose, AppLocalizations l10n) {
    final doseProvider = Provider.of<DoseProvider>(context, listen: false);
    final medication = doseProvider.medicationForDose(dose);
    final theme = Theme.of(context);

    if (medication == null) {
      // Medication might have been deleted, handle gracefully
      return const SizedBox.shrink();
    }

    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (dose.status) {
      case DoseStatus.taken:
        statusIcon = Icons.check_circle;
        statusColor = theme.colorScheme.secondary;
        statusText = l10n.taken;
        break;
      case DoseStatus.skipped:
        statusIcon = Icons.cancel;
        statusColor = theme.colorScheme.error;
        statusText = l10n.skipped;
        break;
      case DoseStatus.pending:
        statusIcon = Icons.hourglass_empty;
        statusColor = theme.colorScheme.onSurface.withAlpha(153);
        statusText = l10n.pending;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(Icons.medical_services_outlined, color: theme.colorScheme.primary),
        title: Text(medication.name, style: theme.textTheme.titleMedium),
        subtitle: Text(l10n.doseAtTime(medication.dosage.toString(), medication.unit, DateFormat.jm().format(dose.time))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, color: statusColor, size: 20),
            const SizedBox(width: 8),
            Text(statusText, style: theme.textTheme.bodyMedium?.copyWith(color: statusColor)),
          ],
        ),
      ),
    );
  }
}
