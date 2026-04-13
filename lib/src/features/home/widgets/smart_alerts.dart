// Flutter imports:
import 'package:flutter/material.dart';

class SmartAlerts extends StatelessWidget {
  const SmartAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amber.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.amber.shade800, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Your Panadol is running low. You might want to refill it soon.',
                style: TextStyle(color: Colors.amber.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
