import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    // Handle notification tapped logic here
  }

  Future<void> init() async {
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
      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
    }
  }

  Future<void> requestPermissions() async {
    try {
      final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
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
    await cancelNotifications(medication.id!);
  }

  Future<void> cancelNotifications(int medicationId) async {
    for (int i = 0; i < 50; i++) {
      try {
        await _notificationsPlugin.cancel(id: _generateNotificationId(medicationId, i));
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
