import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/main/presentation/screens/main_screen.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/presentation/services/dose_service.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';
import 'package:myapp/src/features/medication/scheduling_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/presentation/providers/medication_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.init();

  final medicationRepository = MedicationRepository();
  final doseScheduleRepository = DoseScheduleRepository();
  final schedulingService = SchedulingService();
  final doseService = DoseService(
    doseScheduleRepository,
    schedulingService,
    notificationService,
    medicationRepository,
  );

  Timer.periodic(const Duration(minutes: 1), (timer) {
    doseService.checkMissedDoses();
  });

  runApp(
    MultiProvider(
      providers: [
        Provider<DoseService>.value(value: doseService),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(
          create: (context) => MedicationProvider(
            medicationRepository,
            doseScheduleRepository,
          )..loadMedications(),
        ),
        ChangeNotifierProvider(
          create: (context) => DoseProvider(
            doseScheduleRepository,
            context.read<MedicationProvider>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the core colors for the medical theme
    const primaryColor = Color(0xFF007AFF); // Medical Blue
    const secondaryColor = Color(0xFF34C759); // Success Green
    const errorColor = Color(0xFFFF3B30); // Soft Red for warnings

    // --- Light Theme ---
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF000000),
    );

    final lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: GoogleFonts.latoTextTheme(ThemeData.light().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface),
        iconTheme: IconThemeData(color: lightColorScheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          side: BorderSide(color: lightColorScheme.primary.withAlpha(128)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: lightColorScheme.outline, width: 1),
        ),
        color: lightColorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9F9F9),
    );

    // --- Dark Theme ---
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFFFFFFF),
    );

    final darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface),
        iconTheme: IconThemeData(color: darkColorScheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(color: darkColorScheme.primary.withAlpha(128)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: darkColorScheme.outline, width: 1),
        ),
        color: darkColorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
      ),
      scaffoldBackgroundColor: const Color(0xFF000000),
    );

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'MedAlarm',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settingsProvider.themeMode,
          locale: Provider.of<LocaleProvider>(context).locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          home: const MainScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
