// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/features/settings/data/repositories/profile_repository.dart';
import 'package:myapp/src/features/settings/providers/locale_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/profile_provider.dart';
import 'package:myapp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:myapp/src/navigation/app_router.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Database? database;
  try {
    database = await openDatabase(
      'medications.db',
      version: 4, // Bump version to trigger migration
      onCreate: (db, version) {
        // Correct schema for new installations
        db.execute(
          'CREATE TABLE medications(id INTEGER PRIMARY KEY, name TEXT, dosage REAL, unit TEXT, scheduleType TEXT, times TEXT, stock INTEGER, remaining_doses INTEGER, startDate TEXT, endDate TEXT, daysOfWeek TEXT, interval INTEGER, taken_today INTEGER)',
        );
        db.execute(
          'CREATE TABLE dose_schedules(id INTEGER PRIMARY KEY, medicationId INTEGER, scheduledTime TEXT, status TEXT)',
        );
        db.execute(
          'CREATE TABLE doses(id INTEGER PRIMARY KEY, medicationId INTEGER, time TEXT)',
        );
        db.execute(
          'CREATE TABLE profile(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, weight REAL, height REAL)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE medications ADD COLUMN endDate TEXT');
          // This migration was faulty, creating `weekdays`. It's fixed in the v4 migration.
          await db.execute('ALTER TABLE medications ADD COLUMN weekdays TEXT');
          await db.execute('ALTER TABLE dose_schedules ADD COLUMN status TEXT');
          await db.execute(
            'CREATE TABLE doses(id INTEGER PRIMARY KEY, medicationId INTEGER, time TEXT)',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'CREATE TABLE profile(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, weight REAL, height REAL)',
          );
        }
        if (oldVersion < 4) {
          // Migration to fix schema for existing users
          await db.transaction((txn) async {
            // Add missing columns
            await txn.execute('ALTER TABLE medications ADD COLUMN interval INTEGER');
            await txn.execute('ALTER TABLE medications ADD COLUMN taken_today INTEGER');

            // Rename columns to match the model
            await txn.execute('ALTER TABLE medications RENAME COLUMN weekdays TO daysOfWeek');
            await txn.execute('ALTER TABLE medications RENAME COLUMN remainingDoses TO remaining_doses');
          });
        }
      },
    );
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error: Database could not be initialized. \n$e'),
        ),
      ),
    ));
    return;
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    MyApp(
      database: database,
      sharedPreferences: sharedPreferences,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database, required this.sharedPreferences});

  final Database? database;
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    if (database == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error: Database could not be initialized.'),
          ),
        ),
      );
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProviderImpl(sharedPreferences)),
        ChangeNotifierProvider(
          create: (_) => MedicationProvider(
            MedicationRepository(database: database!),
            DoseScheduleRepository(database: database!),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            ProfileRepository(database: database!),
          ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          final localeProvider = Provider.of<LocaleProvider>(context);
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            title: 'Medication-Tracker',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.teal,
                secondary: Colors.tealAccent,
              ),
            ),
            themeMode: settingsProvider.themeMode,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}

class LocaleProviderImpl extends ChangeNotifier implements LocaleProvider {
  LocaleProviderImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Locale? get locale {
    final langCode = _sharedPreferences.getString('langCode');
    if (langCode == null) {
      return null;
    }
    return Locale(langCode);
  }

  @override
  void setLocale(Locale locale) {
    _sharedPreferences.setString('langCode', locale.languageCode);
    notifyListeners();
  }

  @override
  String getLangName(String langCode) {
    switch (langCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
}
