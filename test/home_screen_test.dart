import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/home/screens/home_screen.dart';
import 'package:myapp/src/features/medication/models/medication.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';

class MockMedicationProvider extends ChangeNotifier
    implements MedicationProvider {
  @override
  List<Medication> get medications => [];

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  Future<void> loadMedications() async {}

  @override
  Future<void> addMedication(Medication medication) async {}

  @override
  Future<void> updateMedication(Medication medication) async {}

  @override
  Future<void> deleteMedication(int id) async {}

  @override
  Medication? getMedication(int id) => null;

  @override
  Future<Medication?> getMedicationById(int id) async => null;

  @override
  Future<void> removeMedication(int id) async {}
}

class MockDoseProvider extends ChangeNotifier implements DoseProvider {
  @override
  bool get isLoading => false;

  @override
  List<Dose> get doses => [];

  @override
  Map<DateTime, List<Dose>> get groupedDosesByDay => {};

  @override
  Future<void> loadDosesForDay(DateTime date) async {}

  @override
  Future<void> loadAllDoses() async {}

  @override
  Future<void> takeDose(Dose dose) async {}

  @override
  Future<void> updateDoseStatus(Dose dose, DoseStatus status) async {}
}

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('HomeScreen shows no medications when medication list is empty',
      (WidgetTester tester) async {
    final mockMedicationProvider = MockMedicationProvider();
    final mockDoseProvider = MockDoseProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MedicationProvider>(
            create: (_) => mockMedicationProvider,
          ),
          ChangeNotifierProvider<DoseProvider>(
            create: (_) => mockDoseProvider,
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No Medications'), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });
}
