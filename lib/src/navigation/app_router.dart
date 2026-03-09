
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/src/features/home/presentation/screens/home_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/add_edit_medication_screen.dart';
import 'package:myapp/src/features/history/presentation/screens/history_screen.dart';
import 'package:myapp/src/features/medication/presentation/screens/medication_details_screen.dart';
import 'package:myapp/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:myapp/src/features/statistics/presentation/screens/statistics_screen.dart';

// Note: Authentication service and Firebase Dynamic Links service would be needed here
// import 'package:myapp/src/services/auth_service.dart';
// import 'package:myapp/src/services/dynamic_link_service.dart';

class AppRouter {
  // final AuthService authService;
  // final DynamicLinkService dynamicLinkService;

  // AppRouter(this.authService, this.dynamicLinkService);

  static final GoRouter router = GoRouter(
    // redirect: (context, state) {
    //   // Example of a route guard
    //   final isAuthenticated = authService.isAuthenticated;
    //   final isGoingToAuth = state.matchedLocation.startsWith('/auth');

    //   if (!isAuthenticated && !isGoingToAuth) {
    //     return '/auth';
    //   }
    //   return null;
    // },
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/medication-details/:id',
        name: 'medication-details',
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id']!;
          return MedicationDetailsScreen(medicationId: id);
        },
      ),
      GoRoute(
        path: '/add-edit-medication',
        name: 'add-edit-medication',
        builder: (BuildContext context, GoRouterState state) => const AddEditMedicationScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (BuildContext context, GoRouterState state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/statistics',
        name: 'statistics',
        builder: (BuildContext context, GoRouterState state) => const StatisticsScreen(),
      ),
    ],
    // initialLocation: '/',
    // errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  // void setupDynamicLinks() {
  //   dynamicLinkService.handleDynamicLinks((path) {
  //     if (path != null) {
  //       router.go(path);
  //     }
  //   });
  // }
}
