import 'package:flutter/material.dart';

class MedicineCards extends StatelessWidget {
  const MedicineCards({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.medication_liquid),
        title: Text('All Medicines'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
