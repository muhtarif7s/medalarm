import 'package:flutter/material.dart';

class DailyStatsCard extends StatelessWidget {
  const DailyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [Text('Taken'), Text('0/2')],
            ),
            Column(
              children: [Text('Skipped'), Text('0')],
            ),
            Column(
              children: [Text('Upcoming'), Text('2')],
            ),
          ],
        ),
      ),
    );
  }
}
