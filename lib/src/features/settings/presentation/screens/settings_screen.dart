import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/settings/presentation/widgets/settings_row.dart';
import 'package:myapp/src/features/settings/presentation/widgets/user_profile_header.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => GoRouter.of(context).pop(),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const UserProfileHeader(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SettingsRow(
            icon: Icons.account_circle_outlined,
            title: 'Edit Profile',
            onPress: () {},
          ),
          SettingsRow(
            icon: Icons.security_outlined,
            title: 'Security',
            onPress: () {},
          ),
          SettingsRow(
            icon: Icons.language_outlined,
            title: 'Language',
            onPress: () {},
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SettingsRow(
            icon: Icons.notifications_outlined,
            title: 'Dose Notifications',
            hasSwitch: true,
            isSwitchOn: _isNotificationsOn,
            onSwitchChange: (value) {
              setState(() {
                _isNotificationsOn = value;
              });
            },
          ),
          SettingsRow(
            icon: Icons.calendar_today_outlined,
            title: 'Reminders',
            onPress: () {},
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('About', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SettingsRow(
            icon: Icons.help_outline,
            title: 'Help',
            onPress: () {},
          ),
          SettingsRow(
            icon: Icons.info_outline,
            title: 'Terms and Conditions',
            subtitle: 'Version 1.0.0',
            onPress: () {},
          ),
        ],
      ),
    );
  }
}
