import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/doses/data/models/dose.dart';
import 'package:myapp/src/features/doses/data/models/dose_schedule.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/history/presentation/screens/history_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'history_screen_test.mocks.dart';
import 'utils/test_go_router.dart';

class MockDoseProvider extends Mock implements DoseProvider {
  @override
  Map<DateTime, List<DoseSchedule>> get groupedDosesByDay => {};

  @override
  Future<void> loadDoses() => Future.value();

  @override
  bool get isLoading => false;

  @override
  Future<Medication?> medicationForDose(DoseSchedule dose) async {
    return Medication(
      id: 1,
      name: 'Aspirin',
      dosage: 100,
      unit: 'mg',
      scheduleType: MedicationScheduleType.daily,
      times: [const TimeOfDay(hour: 8, minute: 0)],
      startDate: DateTime.now(),
      stock: 10,
      remainingDoses: 10,
    );
  }
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

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    verify(mockGoRouter.pop()).called(1);
  });
}
