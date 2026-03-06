import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/home_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/medication_details_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/settings_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/history_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: 'addMedication',
      path: '/add',
      builder: (context, state) => const AddEditMedicationScreen(),
    ),
    GoRoute(
      name: 'editMedication',
      path: '/edit',
      builder: (context, state) {
        final medication = state.extra as Medication?;
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
    body: Center(
      child: Text('Page not found: ${state.error}'),
    ),
  ),
);
