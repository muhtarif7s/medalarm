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
        DropdownButton<String>(
          value: _selectedFrequency,
          onChanged: (String? newValue) {
            setState(() {
              _selectedFrequency = newValue!;
            });
          },
          items: <String>['daily', 'weekly']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value[0].toUpperCase() + value.substring(1)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
