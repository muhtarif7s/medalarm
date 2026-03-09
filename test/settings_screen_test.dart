import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

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

class MockSettingsProvider extends ChangeNotifier implements SettingsProvider {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  ThemeMode get themeMode => _themeMode;

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
  }

  @override
  Future<void> loadSettings() async {}
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

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);

@GenerateMocks([GoRouter])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets(
      'T2.8: On the "Settings" screen, tap the back arrow to return to the home screen',
      (WidgetTester tester) async {
    final mockGoRouter = MockGoRouter();
    final mockSettingsProvider = MockSettingsProvider();
    final mockLocaleProvider = MockLocaleProvider();

    await HttpOverrides.runZoned(
      () async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SettingsProvider>(
                create: (_) => mockSettingsProvider,
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
                child: const SettingsScreen(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();

        verify(mockGoRouter.pop()).called(1);
      },
      createHttpClient: (SecurityContext? context) {
        return MockHttpClient();
      },
    );
  });
}

class MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) {
    return Future.value(MockHttpClientRequest());
  }
}

class MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() {
    return Future.value(MockHttpClientResponse());
  }

  @override
  HttpHeaders get headers => MockHttpHeaders();
}

class MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream.value(kTransparentImage)
        .listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

class MockHttpHeaders extends Fake implements HttpHeaders {}
