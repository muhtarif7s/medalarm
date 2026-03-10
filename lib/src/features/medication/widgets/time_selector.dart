// Flutter imports:
import 'package:flutter/material.dart';

class TimeSelector extends StatelessWidget {
  final List<TimeOfDay> times;
  final void Function(List<TimeOfDay>) onChanged;

  const TimeSelector({super.key, required this.times, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Times', style: Theme.of(context).textTheme.titleMedium),
        ...times.asMap().entries.map((entry) {
          final index = entry.key;
          final time = entry.value;
          return ListTile(
            title: Text(time.format(context)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final newTimes = [...times];
                newTimes.removeAt(index);
                onChanged(newTimes);
              },
            ),
            onTap: () async {
              final newTime = await showTimePicker(context: context, initialTime: time);
              if (newTime != null) {
                final newTimes = [...times];
                newTimes[index] = newTime;
                onChanged(newTimes);
              }
            },
          );
        }),
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Time'),
          onPressed: () async {
            final newTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (newTime != null) {
              onChanged([...times, newTime]);
            }
          },
        ),
      ],
    );
  }
}
