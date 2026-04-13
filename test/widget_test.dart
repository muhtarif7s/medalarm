// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:myapp/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(database: null, sharedPreferences: sharedPreferences));

    // Verify that the app starts.
    expect(find.text('Error: Database could not be initialized.'), findsOneWidget);
  });
}
