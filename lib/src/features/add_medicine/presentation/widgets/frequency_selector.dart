import 'package:flutter/material.dart';

class FrequencySelector extends StatefulWidget {
  const FrequencySelector({super.key});

  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  String _selectedFrequency = 'daily';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Frequency', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Radio(value: 'daily', groupValue: _selectedFrequency, onChanged: (value) => setState(() => _selectedFrequency = value!)),
            const Text('Daily'),
            Radio(value: 'weekly', groupValue: _selectedFrequency, onChanged: (value) => setState(() => _selectedFrequency = value!)),
            const Text('Weekly'),
          ],
        ),
      ],
    );
  }
}
