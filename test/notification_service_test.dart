// Package imports:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;

// Project imports:
import 'package:myapp/src/core/services/notification_service.dart';
import 'notification_service_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;

  setUp(() {
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    notificationService = NotificationService(mockFlutterLocalNotificationsPlugin);
    tz.initializeTimeZones();
  });

  test('T3.1: NotificationService initializes without errors', () async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    when(mockFlutterLocalNotificationsPlugin.initialize(settings: initializationSettings))
        .thenAnswer((_) async => true);
    await notificationService.init();
    verify(mockFlutterLocalNotificationsPlugin.initialize(settings: initializationSettings)).called(1);
  });
}
