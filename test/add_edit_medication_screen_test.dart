import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/add-edit-medication',
            builder: (context, state) => const AddEditMedicationScreen(),
          ),
        ],
        initialLocation: '/add-edit-medication',
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
      when(mockMedicationRepository.addMedication(any)).thenAnswer((_) async => Future.value());

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MedicationProvider(mockMedicationRepository, mockDoseScheduleRepository),
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

      await tester.enterText(find.byKey(const Key('medication_name_field')), medication.name);
      await tester.enterText(find.byKey(const Key('medication_dosage_field')), medication.dosage.toString());
      await tester.enterText(find.byKey(const Key('medication_unit_field')), medication.unit);
      await tester.enterText(find.byKey(const Key('medication_stock_field')), medication.stock.toString());

      await tester.tap(find.byIcon(Icons.save));
      await tester.pumpAndSettle();

      // Assert
      verify(mockMedicationRepository.addMedication(any)).called(1);
    });
  });
}
