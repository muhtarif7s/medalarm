import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [Icon(Icons.add), Text('Add Medicine')],
            ),
            Column(
              children: [Icon(Icons.history), Text('History')],
            ),
            Column(
              children: [Icon(Icons.bar_chart), Text('Statistics')],
            ),
          ],
        ),
      ),
    );
  }
}
