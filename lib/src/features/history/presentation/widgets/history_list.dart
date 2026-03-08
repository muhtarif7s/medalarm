import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final String filter;

  const HistoryList({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data
    final items = [
      _buildHistoryItem(context, 'Panadol', 'Taken at 8:05 AM', true),
      _buildHistoryItem(context, 'Aspirin', 'Skipped at 12:00 PM', false),
      _buildHistoryItem(context, 'Ibuprofen', 'Upcoming at 4:00 PM', null),
    ];

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, String title, String subtitle, bool? taken) {
    return ListTile(
      leading: Icon(
        taken == true ? Icons.check_circle : taken == false ? Icons.cancel : Icons.hourglass_bottom,
        color: taken == true ? Colors.green : taken == false ? Colors.red : Colors.grey,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
