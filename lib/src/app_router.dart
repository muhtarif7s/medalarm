import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/home_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/history_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/settings_screen.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add_medication',
        builder: (BuildContext context, GoRouterState state) => const AddEditMedicationScreen(),
      ),
      GoRoute(
        path: '/edit_medication',
        builder: (BuildContext context, GoRouterState state) {
          final Medication medication = state.extra as Medication;
          return AddEditMedicationScreen(medication: medication);
        },
      ),
      GoRoute(
        path: '/history',
        builder: (BuildContext context, GoRouterState state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Text('The page ${state.uri} could not be found.'),
      ),
    ),
  );
}
