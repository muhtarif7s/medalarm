import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/settings/presentation/providers/locale_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:myapp/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MockLocaleProvider extends Mock implements LocaleProvider {
  @override
  Locale? get locale => const Locale('en');

  @override
  void setLocale(Locale locale) {}

  @override
  String getLangName(String langCode) => 'English';
}

void main() {
  group('SettingsScreen', () {
    late SettingsProvider settingsProvider;
    late MockLocaleProvider mockLocaleProvider;

    setUp(() {
      settingsProvider = SettingsProvider();
      mockLocaleProvider = MockLocaleProvider();
    });

    testWidgets('should display the settings screen', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: settingsProvider),
            ChangeNotifierProvider<LocaleProvider>.value(value: mockLocaleProvider),
          ],
          child: const MaterialApp(
            home: SettingsScreen(),
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
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Notification'), findsOneWidget);
    });
  });
}
