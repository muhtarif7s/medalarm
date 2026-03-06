import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/src/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle(context, 'Appearance'),
          _buildThemeSwitcher(context),
          const Divider(height: 32),
          _buildSectionTitle(context, 'About'),
          _buildAboutListTile(context),
        ],
      ),
    );
  }

  Padding _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme Mode', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: Text('Light'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text('Dark'),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.auto_mode),
                  label: Text('System'),
                ),
              ],
              selected: {themeProvider.themeMode},
              onSelectionChanged: (newSelection) {
                themeProvider.setThemeMode(newSelection.first);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutListTile(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final url = Uri.parse('https://your-privacy-policy-url.com');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Could not launch URL')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
