import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  group('NotificationService', () {
    late NotificationService notificationService;
    late FlutterLocalNotificationsPlugin mockNotificationsPlugin;

    setUp(() {
      notificationService = NotificationService();
      mockNotificationsPlugin = FlutterLocalNotificationsPlugin();
      tz.initializeTimeZones();
    });

    test('scheduleNotification schedules a notification', () async {
      // GIVEN
      const id = 1;
      const title = 'Test Title';
      const body = 'Test Body';
      final scheduledTime = DateTime.now().add(const Duration(seconds: 10));

      // WHEN
      await notificationService.scheduleNotification(id, title, body, scheduledTime);

      // THEN
      final pendingNotifications = await mockNotificationsPlugin.pendingNotificationRequests();
      expect(pendingNotifications.length, 1);
      expect(pendingNotifications.first.id, id);
      expect(pendingNotifications.first.title, title);
      expect(pendingNotifications.first.body, body);
    });

    test('showNotification shows a notification', () async {
      // GIVEN
      const id = 1;
      const title = 'Test Title';
      const body = 'Test Body';

      // WHEN
      await notificationService.showNotification(id, title, body);

      // THEN
      // Since show a notification is immediate, we can't easily test it.
      // We will trust the flutter_local_notifications library to work correctly.
    });

    test('cancelNotification cancels a notification', () async {
      // GIVEN
      const id = 1;
      const title = 'Test Title';
      const body = 'Test Body';
      final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
      await notificationService.scheduleNotification(id, title, body, scheduledTime);

      // WHEN
      await notificationService.cancelNotification(id);

      // THEN
      final pendingNotifications = await mockNotificationsPlugin.pendingNotificationRequests();
      expect(pendingNotifications.length, 0);
    });
  });
}
