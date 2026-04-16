// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;

// Project imports:
import 'package:myapp/src/core/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NotificationService notificationService;

  setUp(() {
    notificationService = NotificationService();
    tz.initializeTimeZones();
  });

  test('T3.1: NotificationService initializes without errors', () async {
    // Since NotificationService is a singleton and creates its own plugin instance,
    // we just test that init() completes without throwing an exception
    await expectLater(notificationService.init(), completes);
  });
}
