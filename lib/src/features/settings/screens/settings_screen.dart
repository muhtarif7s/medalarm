// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/src/features/profile/presentation/providers/profile_provider.dart';
import 'package:myapp/src/features/settings/widgets/edit_profile_dialog.dart';
import 'package:myapp/src/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _doseNotifications;

  @override
  void initState() {
    super.initState();
    final notificationService = Provider.of<NotificationService>(context, listen: false);
    _doseNotifications = notificationService.areNotificationsEnabled();
    Provider.of<ProfileProvider>(context, listen: false).loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    const darkBackgroundColor = Color(0xFF121212);
    const whiteTextColor = Colors.white;

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: whiteTextColor)),
        backgroundColor: darkBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileSection(),
          const SizedBox(height: 20),
          _buildSectionHeader('Notifications'),
          _buildNotificationsSection(),
          const SizedBox(height: 20),
          _buildSectionHeader('About'),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        if (profileProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return GestureDetector(
          onTap: () => _showEditProfileDialog(context, profileProvider),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue,
                child: Text(
                  profileProvider.profile.name.isNotEmpty ? profileProvider.profile.name[0].toUpperCase() : '',
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileProvider.profile.name,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    profileProvider.profile.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.edit, color: Colors.white70),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, ProfileProvider profileProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return EditProfileDialog(
          name: profileProvider.profile.name,
          email: profileProvider.profile.email,
          onSave: (newName, newEmail) async {
            await profileProvider.updateProfile(name: newName, email: newEmail);
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white24),
      ),
      child: ListTile(
        title: const Text('Dose Reminders', style: TextStyle(color: Colors.white)),
        trailing: Switch(
          value: _doseNotifications,
          onChanged: (value) {
            final notificationService = Provider.of<NotificationService>(context, listen: false);
            if (value) {
              notificationService.enableNotifications();
            } else {
              notificationService.disableNotifications();
            }
            setState(() {
              _doseNotifications = value;
            });
          },
          activeThumbColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white24),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
            onTap: () {},
          ),
          const Divider(color: Colors.white24, height: 1),
          ListTile(
            title: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
