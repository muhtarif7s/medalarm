import 'package:flutter/material.dart';

class MedicineCards extends StatelessWidget {
  const MedicineCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Medications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _buildMedicineCard('Panadol', '2 pills left'),
              _buildMedicineCard('Aspirin', '10 pills left'),
              _buildMedicineCard('Ibuprofen', '5 pills left'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildMedicineCard(String name, String stock) {
    return Card(
      child: SizedBox(
        width: 120,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              const Icon(Icons.medication, size: 40),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(stock, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
