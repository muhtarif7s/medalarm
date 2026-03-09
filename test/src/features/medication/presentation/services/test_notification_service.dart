import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    )).called(1);
  });

  test('should cancel a notification', () async {
    // Arrange
    final id = 1;

    // Act
    await notificationService.cancelNotification(id);

    // Assert
    verify(mockFlutterLocalNotificationsPlugin.cancel(id)).called(1);
  });
}
