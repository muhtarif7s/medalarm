import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Text('Good morning'),
      subtitle: Text('Saturday, 15 Dec'),
      trailing: CircleAvatar(
        child: Icon(Icons.person),
      ),
    );
  }
}
