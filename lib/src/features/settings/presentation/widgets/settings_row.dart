import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool hasSwitch;
  final bool isSwitchOn;
  final ValueChanged<bool>? onSwitchChange;
  final VoidCallback? onPress;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.hasSwitch = false,
    this.isSwitchOn = false,
    this.onSwitchChange,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: hasSwitch
          ? Switch(value: isSwitchOn, onChanged: onSwitchChange)
          : const Icon(Icons.arrow_forward_ios),
      onTap: onPress,
    );
  }
}
