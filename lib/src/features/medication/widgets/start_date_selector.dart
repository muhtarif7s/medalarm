// Flutter imports:
import 'package:flutter/material.dart';

class StartDateSelector extends StatefulWidget {
  final void Function(DateTime) onChanged;

  const StartDateSelector({super.key, required this.onChanged});

  @override
  State<StartDateSelector> createState() => _StartDateSelectorState();
}

class _StartDateSelectorState extends State<StartDateSelector> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.onChanged(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Text('${_selectedDate.toLocal()}'.split(' ')[0], style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
