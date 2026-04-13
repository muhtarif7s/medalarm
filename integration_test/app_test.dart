import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Complete End-to-End Test", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Home Screen
    expect(find.text('Medication Tracker'), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Add Medication Screen
    expect(find.text('Add Medication'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('medication_name')), 'Test Medication');
    await tester.enterText(find.byKey(const Key('medication_dosage')), '10');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Home Screen Verification
    expect(find.text('Test Medication'), findsOneWidget);

    // Edit Medication
    await tester.tap(find.text('Test Medication'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('medication_name')), 'Updated Medication');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Updated Medication'), findsOneWidget);

    // Delete Medication
    await tester.tap(find.text('Updated Medication'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.text('Updated Medication'), findsNothing);

    // Navigation
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(find.text('History'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();
    expect(find.text('Statistics'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    // Stability
    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.bar_chart));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
    }
  });
}
