import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/settings/presentation/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'add_edit_medication_screen_test.mocks.dart';
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

class MockLocaleProvider extends ChangeNotifier implements LocaleProvider {
  Locale _locale = const Locale('en');

  @override
  Locale get locale => _locale;

  @override
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  @override
  String getLangName(String langCode) {
    switch (langCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return '';
    }
  }
}

@GenerateNiceMocks([MockSpec<GoRouter>()])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('T2.2: On the "Add/Edit Medication" screen, tap the back arrow to return to the home screen', (WidgetTester tester) async {
    final mockGoRouter = MockGoRouter();
    final mockMedicationProvider = MockMedicationProvider();
    final mockLocaleProvider = MockLocaleProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MedicationProvider>(
            create: (_) => mockMedicationProvider,
          ),
          ChangeNotifierProvider<LocaleProvider>(
            create: (_) => mockLocaleProvider,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestGoRouter(
            goRouter: mockGoRouter,
            child: const AddEditMedicationScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    verify(mockGoRouter.pop()).called(1);
  });
}
