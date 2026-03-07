import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';

void main() {
  // Initialize the Flutter binding for the test environment
  TestWidgetsFlutterBinding.ensureInitialized();

  test('NotificationService initializes without errors', () async {
    // Arrange
    final notificationService = NotificationService();

    // Act & Assert
    // This will throw an exception if initialization fails, causing the test to fail.
    await notificationService.init();
    
    // If we reach here, it means init() completed without throwing.
    expect(true, isTrue);
  });
}
