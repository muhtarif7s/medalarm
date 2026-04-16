import 'package:flutter/material.dart';

class TimelineItem extends StatelessWidget {
  final String time;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final bool isCompleted;

  const TimelineItem({
    super.key,
    required this.time,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time and icon column
        SizedBox(
          width: 60,
          child: Column(
            children: [
              Text(
                time,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (iconColor ?? theme.colorScheme.primary)
                      .withValues(alpha: isCompleted ? 0.2 : 1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: isCompleted
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color:
                      isCompleted ? theme.colorScheme.onSurfaceVariant : null,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
