import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

    setUp(() {
      mockMedicationRepository = MockMedicationRepository();
      mockDoseScheduleRepository = MockDoseScheduleRepository();
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

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MedicationProvider(mockMedicationRepository, mockDoseScheduleRepository),
            ),
          ],
          child: const MaterialApp(
            home: AddEditMedicationScreen(),
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
      await tester.enterText(find.byType(TextFormField).at(0), medication.name);
      await tester.enterText(find.byType(TextFormField).at(1), medication.dosage.toString());
      await tester.enterText(find.byType(TextFormField).at(2), medication.unit);
      await tester.enterText(find.byType(TextFormField).at(3), medication.stock.toString());
      await tester.tap(find.byIcon(Icons.save_alt_outlined));
      await tester.pump();

      // Assert
      verify(mockMedicationRepository.addMedication(any)).called(1);
    });
  });
}
