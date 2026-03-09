import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/history/presentation/screens/history_screen.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'medication_provider_test.mocks.dart';

void main() {
  group('HistoryScreen', () {
    late MockMedicationRepository mockMedicationRepository;
    late MockDoseScheduleRepository mockDoseScheduleRepository;

    setUp(() {
      mockMedicationRepository = MockMedicationRepository();
      mockDoseScheduleRepository = MockDoseScheduleRepository();
    });

    testWidgets('should display the list of medications', (WidgetTester tester) async {
      // Arrange
      final medications = [
        Medication(
          id: 1,
          name: 'Medication 1',
          dosage: 1.0,
          unit: 'mg',
          scheduleType: MedicationScheduleType.daily,
          times: const [TimeOfDay(hour: 8, minute: 0)],
          stock: 10,
          remainingDoses: 10,
          startDate: DateTime.now(),
        ),
        Medication(
          id: 2,
          name: 'Medication 2',
          dosage: 2.0,
          unit: 'mg',
          scheduleType: MedicationScheduleType.daily,
          times: const [TimeOfDay(hour: 8, minute: 0)],
          stock: 20,
          remainingDoses: 20,
          startDate: DateTime.now(),
        ),
      ];
      when(mockMedicationRepository.getAllMedications()).thenAnswer((_) async => medications);

      final doseSchedules = medications.map((medication) => DoseSchedule(
        id: medication.id!,
        medicationId: medication.id!,
        scheduledTime: DateTime(2024, 1, 1, medication.times.first.hour, medication.times.first.minute),
      )).toList();
      when(mockDoseScheduleRepository.getDoseSchedulesForMedication(any)).thenAnswer((_) async => doseSchedules);

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MedicationProvider(mockMedicationRepository, mockDoseScheduleRepository),
            ),
          ],
          child: const MaterialApp(
            home: HistoryScreen(),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('History'), findsOneWidget);
    });
  });
}
