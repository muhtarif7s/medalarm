import 'package:flutter/material.dart';

class NextDoseCard extends StatelessWidget {
  const NextDoseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.medication),
        title: Text('Panadol'),
        subtitle: Text('Next dose in 2h 30m'),
        trailing: Text('1 pill'),
      ),
    );
  }
}
