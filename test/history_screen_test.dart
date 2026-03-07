import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/screens/history_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'history_screen_test.mocks.dart';
import 'utils/test_go_router.dart';

class MockDoseProvider extends ChangeNotifier implements DoseProvider {
  @override
  List<Dose> get doses => [];

  @override
  bool get isLoading => false;

  @override
  Map<DateTime, List<Dose>> get groupedDosesByDay => {};

  @override
  Medication? medicationForDose(Dose dose) => null;

  @override
  Future<void> loadDoses() async {}

  @override
  Future<void> loadDosesForMedication(int medicationId) async {}

  @override
  Future<void> updateDoseStatus(Dose dose, DoseStatus status) async {}
  
  @override
  void addListener(VoidCallback listener) {}
}

@GenerateMocks([GoRouter])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('T2.6: On the "History" screen, tap the back arrow to return to the home screen', (WidgetTester tester) async {
    final mockGoRouter = MockGoRouter();
    final mockDoseProvider = MockDoseProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<DoseProvider>(
            create: (_) => mockDoseProvider,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestGoRouter(
            goRouter: mockGoRouter,
            child: const HistoryScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    verify(mockGoRouter.go('/')).called(1);
  });
}
