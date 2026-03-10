// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Project imports:
import 'package:myapp/src/core/services/notification_service.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;

  setUp(() {
    notificationService = NotificationService();
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
  });

  test('should schedule a notification', () async {
    // Arrange
    final id = 1;
    final title = 'Test Title';
    final body = 'Test Body';
    final scheduledDate = DateTime.now().add(const Duration(seconds: 5));

    // Act
    await notificationService.scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
    );

    // Assert
    verify(mockFlutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: const NotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        ));
  });

  test('should cancel a notification', () async {
    // Arrange
    final id = 1;

    // Act
    await notificationService.cancelNotification(id: id);

    // Assert
    verify(mockFlutterLocalNotificationsPlugin.cancel(id: id)).called(1);
  });
}
