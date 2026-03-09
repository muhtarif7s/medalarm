import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Fake
    implements FlutterLocalNotificationsPlugin {
  bool isInitialized = false;
  List<int> canceledNotifications = [];
  List<dynamic> scheduledNotifications = [];

  @override
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
        onDidReceiveBackgroundNotificationResponse,
  }) async {
    isInitialized = true;
    return true;
  }

  @override
  Future<void> cancel(int id, {String? tag}) async {
    canceledNotifications.add(id);
  }

  @override
  Future<void> show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) async {
    scheduledNotifications.add({'id': id, 'title': title, 'body': body});
  }

  @override
  Future<void> zonedSchedule(
    int id,
    String? title,
    String? body,
    tz.TZDateTime scheduledDate,
    NotificationDetails notificationDetails, {
    required UILocalNotificationDateInterpretation uiLocalNotificationDateInterpretation,
    bool androidAllowWhileIdle = false,
    AndroidScheduleMode? androidScheduleMode,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    scheduledNotifications.add({
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate
    });
  }

  @override
  Future<void> cancelAll() async {
    canceledNotifications.clear();
    scheduledNotifications.clear();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockNotificationsPlugin;

  const MethodChannel channel = MethodChannel(
    'dexterous.com/flutter/local_notifications',
  );

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'initialize') {
        return true;
      }
      if (methodCall.method == 'pendingNotificationRequests') {
        return [];
      }
      return null;
    });

    notificationService = NotificationService();
    mockNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('T3.1: NotificationService initializes without errors', () async {
    await notificationService.init();
  });
}
