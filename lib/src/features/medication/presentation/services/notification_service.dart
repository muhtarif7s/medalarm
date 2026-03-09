import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    tz.initializeTimeZones();
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
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      );
      await requestPermissions();
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
      rethrow; // Re-throw the exception to fail the test
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

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // Replace with your channel ID
          'your_channel_name', // Replace with your channel name
          channelDescription: 'your_channel_description', // Replace with your channel description
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
  ) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id', // Replace with your channel ID
          'your_channel_name', // Replace with your channel name
          channelDescription: 'your_channel_description', // Replace with your channel description
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
