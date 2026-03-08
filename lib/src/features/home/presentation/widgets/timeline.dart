import 'package:flutter/material.dart';

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today's Timeline', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                Text('8:00 AM'),
                SizedBox(width: 16),
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Panadol (1 pill)'),
              ],
            ),
            Row(
              children: [
                Text('12:00 PM'),
                SizedBox(width: 16),
                Icon(Icons.radio_button_unchecked),
                SizedBox(width: 8),
                Text('Panadol (1 pill)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
