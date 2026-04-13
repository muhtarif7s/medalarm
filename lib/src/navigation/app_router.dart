// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/src/features/history/screens/history_screen.dart';
import 'package:myapp/src/features/home/screens/home_screen.dart';
import 'package:myapp/src/features/medication/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/medication/screens/medication_details_screen.dart';
import 'package:myapp/src/features/settings/screens/settings_screen.dart';
import 'package:myapp/src/features/statistics/screens/statistics_screen.dart';
import 'package:myapp/src/navigation/scaffold_with_nested_navigation.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home',
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(
            navigationShell: navigationShell,
            navigationDestinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: AppLocalizations.of(context)?.home ?? 'Home',
              ),
              NavigationDestination(
                icon: const Icon(Icons.history_outlined),
                selectedIcon: const Icon(Icons.history),
                label: AppLocalizations.of(context)?.history ?? 'History',
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: AppLocalizations.of(context)?.statistics ?? 'Statistics',
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: AppLocalizations.of(context)?.settings ?? 'Settings',
              ),
            ],
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/statistics',
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/add-medicine',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final medicationId = state.extra as int?;
          return AddEditMedicationScreen(medicationId: medicationId);
        },
      ),
      GoRoute(
        path: '/medicine-details/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final medicationId = state.pathParameters['id']!;
          return MedicationDetailsScreen(medicationId: medicationId);
        },
      ),
    ],
  );
}
