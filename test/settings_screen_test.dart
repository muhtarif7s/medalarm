import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/settings/presentation/providers/locale_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:myapp/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'settings_screen_test.mocks.dart';
import 'utils/test_go_router.dart';

class MockSettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
  }
}

class MockLocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

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

@GenerateMocks([GoRouter])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('T2.8: On the "Settings" screen, tap the back arrow to return to the home screen', (WidgetTester tester) async {
    final mockGoRouter = MockGoRouter();
    final mockSettingsProvider = MockSettingsProvider();
    final mockLocaleProvider = MockLocaleProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>(
            create: (_) => mockSettingsProvider as SettingsProvider,
          ),
          ChangeNotifierProvider<LocaleProvider>(
            create: (_) => mockLocaleProvider as LocaleProvider,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TestGoRouter(
            goRouter: mockGoRouter,
            child: const SettingsScreen(),
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
