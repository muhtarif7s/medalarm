import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myapp/src/core/services/notification_service.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/features/profile/data/repositories/profile_repository.dart';
import 'package:myapp/src/features/profile/presentation/providers/profile_provider.dart';
import 'package:myapp/src/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await _openDatabase();
  final notificationService = NotificationService();

  try {
    await notificationService.init();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
  }

  runApp(MyApp(database: database, notificationService: notificationService));
}

Future<Database> _openDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'medalarm.db');
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE medications(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          dosage REAL NOT NULL,
          unit TEXT NOT NULL,
          stock INTEGER NOT NULL,
          scheduleType TEXT NOT NULL,
          times TEXT NOT NULL, -- JSON list of TimeOfDay
          startDate TEXT NOT NULL,
          remainingDoses INTEGER NOT NULL,
          daysOfWeek TEXT -- JSON list of DayOfWeek
        )
        ''');

      await db.execute('''
        CREATE TABLE dose_schedules(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          medicationId INTEGER NOT NULL,
          scheduledTime TEXT NOT NULL,
          status TEXT NOT NULL,
          FOREIGN KEY (medicationId) REFERENCES medications (id)
        )
        ''');

      await db.execute('''
        CREATE TABLE profile(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          avatarUrl TEXT
        )
        ''');
    },
  );
}

class MyApp extends StatelessWidget {
  final Database? database;
  final SharedPreferences? sharedPreferences;
  final NotificationService notificationService;
  const MyApp(
      {super.key,
      required this.database,
      this.sharedPreferences,
      required this.notificationService});

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
        if (sharedPreferences != null)
          Provider<SharedPreferences?>.value(value: sharedPreferences),
        Provider<NotificationService>.value(value: notificationService),
        Provider<ProfileRepository>(
          create: (_) => ProfileRepository(),
        ),
        Provider<MedicationRepository>(
          create: (_) => MedicationRepository(database: database!),
        ),
        Provider<DoseRepository>(
          create: (_) => DoseRepository(database: database!),
        ),
        Provider<DoseScheduleRepository>(
          create: (_) => DoseScheduleRepository(database: database!),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(
            context.read<ProfileRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => MedicationProvider(
            context.read<MedicationRepository>(),
            context.read<DoseScheduleRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DoseProvider(
            context.read<DoseRepository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'MedAlarm',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2), // Modern blue
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          cardTheme: const CardThemeData(
            elevation: 2,
            shadowColor: Color(0x1F000000), // 12% black
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 8,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1976D2),
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          cardTheme: const CardThemeData(
            elevation: 2,
            shadowColor: Color(0x4D000000), // 30% black
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 8,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
