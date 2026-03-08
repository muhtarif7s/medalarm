import 'package:flutter/material.dart';

class SmartAlerts extends StatelessWidget {
  const SmartAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.warning_amber_rounded),
        title: Text('Low on Panadol'),
        subtitle: Text('You have 5 pills left'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
