// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/settings/data/repositories/profile_repository.dart';
import 'package:myapp/src/features/settings/providers/locale_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/profile_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:myapp/src/features/settings/screens/settings_screen.dart';

class MockLocaleProvider extends Mock implements LocaleProvider {
  @override
  Locale? get locale => const Locale('en');

  @override
  void setLocale(Locale locale) {}

  @override
  String getLangName(String langCode) => 'English';
}

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  group('SettingsScreen', () {
    late SettingsProvider settingsProvider;
    late MockLocaleProvider mockLocaleProvider;
    late ProfileProvider profileProvider;
    late MockProfileRepository mockProfileRepository;

    setUp(() {
      settingsProvider = SettingsProvider();
      mockLocaleProvider = MockLocaleProvider();
      mockProfileRepository = MockProfileRepository();
      profileProvider = ProfileProvider(mockProfileRepository);
    });

    testWidgets('should display the settings screen', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: settingsProvider),
            ChangeNotifierProvider<LocaleProvider>.value(value: mockLocaleProvider),
            ChangeNotifierProvider.value(value: profileProvider),
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
      expect(find.text('Dose Reminders'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
    });
  });
}
