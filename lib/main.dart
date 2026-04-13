import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_repository.dart';
import 'package:myapp/src/features/doses/data/repositories/dose_schedule_repository.dart';
import 'package:myapp/src/features/doses/presentation/providers/dose_provider.dart';
import 'package:myapp/src/features/medication/data/repositories/medication_repository.dart';
import 'package:myapp/src/features/medication/providers/medication_provider.dart';
import 'package:myapp/src/navigation/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await _openDatabase();

  runApp(MyApp(database: database));
}

Future<Database> _openDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'medalarm.db');
  return await openDatabase(path, version: 1);
}

class MyApp extends StatelessWidget {
  final Database? database;
  final SharedPreferences? sharedPreferences;
  const MyApp({super.key, required this.database, this.sharedPreferences});

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
        title: 'Medication App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.latoTextTheme(),
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.latoTextTheme(
            ThemeData.dark().textTheme,
          ),
        ),
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
