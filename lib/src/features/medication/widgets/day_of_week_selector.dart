// Flutter imports:
import 'package:flutter/material.dart';

class DayOfWeekSelector extends StatelessWidget {
  final List<int> selectedDays;
  final void Function(List<int>) onChanged;

  const DayOfWeekSelector({super.key, required this.selectedDays, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: List.generate(7, (index) {
        final day = index + 1;
        final isSelected = selectedDays.contains(day);
        return ChoiceChip(
          label: Text(getDayAbbreviation(day)),
          selected: isSelected,
          onSelected: (selected) {
            final newSelectedDays = [...selectedDays];
            if (selected) {
              newSelectedDays.add(day);
            } else {
              newSelectedDays.remove(day);
            }
            onChanged(newSelectedDays);
          },
        );
      }).toList(),
    );
  }

  String getDayAbbreviation(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
