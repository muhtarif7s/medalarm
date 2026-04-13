// Flutter imports:
import 'package:flutter/material.dart';

class NextDoseCard extends StatelessWidget {
  const NextDoseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Next Dose', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.medical_services_outlined, size: 40),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Panadol', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('2 pills - 8:00 AM', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Take'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
