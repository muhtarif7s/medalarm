import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          // TODO: Replace with actual user image
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        SizedBox(height: 10),
        Text(
          'John Doe',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          'john.doe@example.com',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
