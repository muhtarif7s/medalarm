import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/home_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/medication_details_screen.dart';
import 'package:myapp/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/history_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: 'addMedication',
        path: '/add_medication',
        builder: (context, state) => const AddEditMedicationScreen(),
      ),
      GoRoute(
        name: 'editMedication',
        path: '/edit',
        builder: (context, state) {
          final medication = state.extra as Medication;
          return AddEditMedicationScreen(medication: medication);
        },
      ),
      GoRoute(
        name: 'medicationDetails',
        path: '/details',
        builder: (context, state) {
          final medication = state.extra as Medication;
          return MedicationDetailScreen(medication: medication);
        },
      ),
      GoRoute(
        name: 'settings',
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        name: 'history',
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
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
