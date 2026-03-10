// Flutter imports:
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _doseNotifications = true;

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
          _buildProfileSection("User", "user@example.com"), // Placeholder data
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

  Widget _buildProfileSection(String name, String email) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue,
          child: Text('U', style: TextStyle(fontSize: 40, color: Colors.white)), // Placeholder
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(email, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ],
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
