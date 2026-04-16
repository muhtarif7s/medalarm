// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/screens/add_edit_medication_screen.dart';
import 'medication_provider_test.mocks.dart';

void main() {
  group('AddEditMedicationScreen', () {
    late MockMedicationRepository mockMedicationRepository;
    late MockDoseScheduleRepository mockDoseScheduleRepository;
    late GoRouter router;

    setUp(() {
      mockMedicationRepository = MockMedicationRepository();
      mockDoseScheduleRepository = MockDoseScheduleRepository();

      router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => context.push('/add-edit-medication'),
                child: const Text('Go to Add/Edit'),
              ),
            ),
          ),
          GoRoute(
            path: '/add-edit-medication',
            builder: (context, state) => const AddEditMedicationScreen(),
          ),
        ],
      );
    });

    testWidgets('should add a medication', (WidgetTester tester) async {
      // Arrange
      final medication = Medication(
        id: 1,
        name: 'Medication 1',
        dosage: 1.0,
        unit: 'mg',
        scheduleType: MedicationScheduleType.daily,
        times: const [TimeOfDay(hour: 8, minute: 0)],
        stock: 10,
        remainingDoses: 10,
        startDate: DateTime.now(),
      );
      when(mockMedicationRepository.addMedication(any))
          .thenAnswer((_) async => 1);

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MedicationProvider(
                  mockMedicationRepository, mockDoseScheduleRepository),
            ),
          ],
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Go to Add/Edit'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.labelText == 'Name'),
        medication.name,
      );
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.labelText == 'Dosage'),
        medication.dosage.toString(),
      );
      await tester.tap(find.text('pill')); // Default value
      await tester.pumpAndSettle();
      await tester.tap(find.text(medication.unit).last);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byWidgetPredicate((widget) =>
            widget is TextField && widget.decoration?.labelText == 'Stock'),
        medication.stock.toString(),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Assert
      verify(mockMedicationRepository.addMedication(any)).called(1);
      expect(find.text('Go to Add/Edit'), findsOneWidget);
    });
  });
}
