import 'package:flutter/material.dart';

class TimeSelector extends StatefulWidget {
  final void Function(TimeOfDay) onChanged;

  const TimeSelector({super.key, required this.onChanged});

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        widget.onChanged(_selectedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(context),
          child: Text(_selectedTime.format(context), style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
