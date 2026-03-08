import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAction(context, Icons.add, 'Add Medicine'),
        _buildAction(context, Icons.history, 'View History'),
        _buildAction(context, Icons.pie_chart, 'View Report'),
      ],
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        IconButton.filled(
          onPressed: () {},
          icon: Icon(icon, size: 30),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(25),
            foregroundColor: Theme.of(context).colorScheme.primary
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
