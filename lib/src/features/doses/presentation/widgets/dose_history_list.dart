// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';

class DoseHistoryList extends StatelessWidget {
  final List<Dose> doses;

  const DoseHistoryList({super.key, required this.doses});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (doses.isEmpty) {
      return Center(
        child: Text(l10n.noDosesInCategory),
      );
    }
    return ListView.builder(
      shrinkWrap: true, // Added to allow the ListView to be in a Column
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling of the list
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: doses.length,
      itemBuilder: (context, index) {
        final dose = doses[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: ListTile(
            leading: _buildStatusIcon(dose.status),
            title: Text(DateFormat.yMMMd().add_jm().format(dose.time)),
            subtitle: Text('${l10n.status}: ${dose.status.name}'),
            trailing: _buildPopupMenu(context, dose, l10n),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(DoseStatus status) {
    switch (status) {
      case DoseStatus.taken:
        return const Icon(Icons.check_circle, color: Colors.green);
      case DoseStatus.skipped:
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.hourglass_empty, color: Colors.grey);
    }
  }

  Widget _buildPopupMenu(
      BuildContext context, Dose dose, AppLocalizations l10n) {
    final doseProvider = Provider.of<DoseProvider>(context, listen: false);

    return PopupMenuButton<DoseStatus>(
      icon: const Icon(Icons.more_vert),
      onSelected: (DoseStatus newStatus) async {
        if (dose.status != newStatus) {
          final confirmed = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(l10n.confirmAction),
              content:
                  Text(l10n.areYouSureYouWantToMarkThisDoseAs(newStatus.name)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(l10n.cancel)),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(l10n.confirm)),
              ],
            ),
          );

          if (confirmed == true) {
            doseProvider.updateDoseStatus(dose, newStatus);
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<DoseStatus>>[
        PopupMenuItem<DoseStatus>(
          value: DoseStatus.taken,
          child: Text(l10n.markAsTaken),
        ),
        PopupMenuItem<DoseStatus>(
          value: DoseStatus.skipped,
          child: Text(l10n.markAsSkipped),
        ),
      ],
    );
  }
}
