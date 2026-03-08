import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'home_screen_test.mocks.dart';
import 'utils/test_go_router.dart';

class MockMedicationProvider extends ChangeNotifier implements MedicationProvider {
  @override
  List<Medication> get medications => [];

  @override
  bool get isLoading => false;

  @override
  Future<void> init() async {}

  @override
  Future<void> loadMedications() async {}

  @override
  Future<void> addMedication(Medication medication) async {}

  @override
  Future<void> updateMedication(Medication medication) async {}

  @override
  Future<void> deleteMedication(int id) async {}

  @override
  Future<Medication?> getMedication(int id) async => null;
}

@GenerateMocks([GoRouter])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('T2.1: Tap "Add Medication" to go to the "Add/Edit Medication" screen', (WidgetTester tester) async {
    final mockGoRouter = MockGoRouter();
    final mockMedicationProvider = MockMedicationProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MedicationProvider>(
            create: (_) => mockMedicationProvider,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestGoRouter(
            goRouter: mockGoRouter,
            child: const HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add Medication'));
    await tester.pumpAndSettle();

    verify(mockGoRouter.go('/add_medication')).called(1);
  });

  testWidgets('T2.5: Tap "History" to go to the "History" screen', (WidgetTester tester) async {
    final mockGoRouter = MockGoRouter();
    final mockMedicationProvider = MockMedicationProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MedicationProvider>(
            create: (_) => mockMedicationProvider,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestGoRouter(
            goRouter: mockGoRouter,
            child: const HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    verify(mockGoRouter.go('/history')).called(1);
  });

  testWidgets('T2.7: Tap "Settings" to go to the "Settings" screen', (WidgetTester tester) async {
    final mockGoRouter = MockGoRouter();
    final mockMedicationProvider = MockMedicationProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MedicationProvider>(
            create: (_) => mockMedicationProvider,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestGoRouter(
            goRouter: mockGoRouter,
            child: const HomeScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    verify(mockGoRouter.go('/settings')).called(1);
  });
}
