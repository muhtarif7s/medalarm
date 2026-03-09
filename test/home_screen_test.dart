import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/home/presentation/screens/home_screen.dart';
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
  Future<Medication?> getMedication(int id) async => null;

  @override
  Future<void> resetMedicationStatusIfNeeded() async {}
  
  @override
  Medication? getMedicationById(String id) => null;
}

@GenerateNiceMocks([MockSpec<GoRouter>()])
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

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    verify(mockGoRouter.go('/add-edit-medication')).called(1);
  });
}
