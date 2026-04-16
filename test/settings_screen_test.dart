// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/profile/data/repositories/profile_repository.dart';
import 'package:myapp/src/features/profile/models/profile.dart';
import 'package:myapp/src/features/profile/presentation/providers/profile_provider.dart';
import 'package:myapp/src/features/settings/providers/locale_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:myapp/src/features/settings/screens/settings_screen.dart';
import 'settings_screen_test.mocks.dart';

@GenerateMocks([ProfileRepository])
class MockLocaleProvider extends Mock implements LocaleProvider {
  @override
  Locale get locale => const Locale('en');

  @override
  Future<void> setLocale(Locale locale) async {}

  @override
  String getLangName(String langCode) => 'English';
}

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

      // Stub the getProfile method to return a Future<Profile>
      when(mockProfileRepository.getProfile()).thenAnswer(
        (_) async => Profile(name: 'Test User', email: 'test@example.com'),
      );
    });

    testWidgets('should display the settings screen',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: settingsProvider),
            ChangeNotifierProvider<LocaleProvider>.value(
                value: mockLocaleProvider),
            ChangeNotifierProvider.value(value: profileProvider),
          ],
          child: MaterialApp(
            home: const SettingsScreen(),
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
