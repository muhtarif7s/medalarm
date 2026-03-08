import 'package:flutter/material.dart';

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        // TODO: Implement a more dynamic timeline
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimelineItem('8 AM', true),
            _buildTimelineItem('12 PM', false),
            _buildTimelineItem('4 PM', false),
            _buildTimelineItem('8 PM', false),
          ],
        ),
      ],
    );
  }

  static Widget _buildTimelineItem(String time, bool isNext) {
    return Column(
      children: [
        Text(time, style: TextStyle(fontWeight: isNext ? FontWeight.bold : FontWeight.normal)),
        Icon(isNext ? Icons.circle : Icons.circle_outlined, size: 16),
      ],
    );
  }
}
