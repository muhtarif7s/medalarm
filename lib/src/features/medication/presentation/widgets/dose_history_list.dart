import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/features/medication/data/models/dose.dart';
import 'package:myapp/src/features/medication/presentation/providers/dose_provider.dart';

class DoseHistoryList extends StatelessWidget {
  final List<Dose> doses;

  const DoseHistoryList({super.key, required this.doses});

  @override
  Widget build(BuildContext context) {
    if (doses.isEmpty) {
      return const Center(
        child: Text('No doses in this category.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      itemCount: doses.length,
      itemBuilder: (context, index) {
        final dose = doses[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: ListTile(
            leading: _buildStatusIcon(dose.status),
            title: Text(DateFormat.yMMMd().add_jm().format(dose.time)),
            subtitle: Text('Status: ${dose.status.name}'),
            trailing: _buildPopupMenu(context, dose),
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
      case DoseStatus.pending:
        return const Icon(Icons.hourglass_empty, color: Colors.grey);
    }
  }

  Widget _buildPopupMenu(BuildContext context, Dose dose) {
    final doseProvider = Provider.of<DoseProvider>(context, listen: false);

    return PopupMenuButton<DoseStatus>(
      icon: const Icon(Icons.more_vert),
      onSelected: (DoseStatus newStatus) {
        if (dose.status != newStatus) {
          final updatedDose = dose.copyWith(status: newStatus);
          doseProvider.updateDose(updatedDose);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<DoseStatus>>[
        const PopupMenuItem<DoseStatus>(
          value: DoseStatus.taken,
          child: Text('Mark as Taken'),
        ),
        const PopupMenuItem<DoseStatus>(
          value: DoseStatus.skipped,
          child: Text('Mark as Skipped'),
        ),
        const PopupMenuItem<DoseStatus>(
          value: DoseStatus.pending,
          child: Text('Mark as Pending'),
        ),
      ],
    );
  }
}
