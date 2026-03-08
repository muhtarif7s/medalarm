import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good morning,', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Ahmed', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, size: 30)),
      ],
    );
  }
}
