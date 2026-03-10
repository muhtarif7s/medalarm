// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:myapp/src/features/settings/data/models/profile_model.dart';

class UserProfileHeader extends StatelessWidget {
  final Profile? profile;

  const UserProfileHeader({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          child: profile == null
              ? const Icon(
                  Icons.person,
                  size: 50,
                )
              : Text(
                  profile!.name.isNotEmpty ? profile!.name[0] : 'A',
                  style: const TextStyle(fontSize: 40),
                ),
        ),
        const SizedBox(height: 10),
        Text(
          profile?.name ?? 'Anonymous',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
