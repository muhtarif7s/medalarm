import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // This initialization is the likely source of the startup crash.
    // It's temporarily disabled in main.dart to confirm.

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    try {
      await _notificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
    }
  }

  Future<void> requestPermissions() async {
    try {
      final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.requestExactAlarmsPermission();
        await androidPlugin.requestNotificationsPermission();
      }

      final iOSPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iOSPlugin != null) {
        await iOSPlugin.requestPermissions(alert: true, badge: true, sound: true);
      }
    } catch (e) {
      debugPrint('Failed to request notification permissions: $e');
    }
  }

  Future<void> scheduleNotifications(
      Medication medication, String title, String body) async {
    // Scheduling is temporarily disabled to prevent startup crashes.
    await cancelNotifications(medication.id!);
  }

  Future<void> cancelNotifications(int medicationId) async {
    for (int i = 0; i < 50; i++) {
      try {
        await _notificationsPlugin.cancel(_generateNotificationId(medicationId, i));
      } catch (e) {
        debugPrint(
            'Failed to cancel notification ID ${_generateNotificationId(medicationId, i)}: $e');
      }
    }
  }

  int _generateNotificationId(int medicationId, int index) {
    return (medicationId << 8) + index;
  }
}
