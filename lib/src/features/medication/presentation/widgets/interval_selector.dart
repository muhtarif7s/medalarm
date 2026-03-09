import 'package:flutter/material.dart';

class IntervalSelector extends StatelessWidget {
  final int selectedInterval;
  final void Function(int) onChanged;

  const IntervalSelector(
      {super.key, required this.selectedInterval, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Every'),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: selectedInterval,
          items: List.generate(30, (index) => index + 1)
              .map((interval) => DropdownMenuItem(
                    value: interval,
                    child: Text(interval.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        const SizedBox(width: 8),
        const Text('days'),
      ],
    );
  }
}
