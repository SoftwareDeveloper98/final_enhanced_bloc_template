import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_page.dart';
// Import other feature pages/routes here
// import '../../features/settings/presentation/pages/settings_page.dart'; 
// import '../../features/auth/presentation/pages/login_page.dart';

// TODO: Implement Authentication Service/State
class AuthService {
  bool isLoggedIn = false; // Mock auth state
}

final AuthService authService = AuthService(); // Simple instance for example

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  // TODO: Add shell navigator keys if using ShellRoute for persistent navigation

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true, // Log routing diagnostics in debug mode

    // === ROUTE DEFINITIONS ===
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
        // Example of nested routes within a feature (if needed)
        // routes: [
        //   GoRoute(
        //     path: 'details/:itemId',
        //     builder: (context, state) {
        //       final itemId = state.pathParameters['itemId']!;
        //       // Example: Pass parameter type-safely (consider using 'extra' for complex objects)
        //       return ItemDetailsPage(itemId: itemId);
        //     },
        //   ),
        // ],
      ),
      // --- Add other top-level routes here ---
      // Example: Settings Route
      // GoRoute(
      //   path: AppRoutes.settings,
      //   builder: (context, state) => const SettingsPage(),
      // ),
      // Example: Login Route
      // GoRoute(
      //   path: AppRoutes.login,
      //   builder: (context, state) => const LoginPage(),
      // ),

      // --- Feature Route Aggregation Example ---
      // Uncomment and implement feature-specific route definitions
      // ...AuthRoutes.routes,
      // ...SettingsRoutes.routes,
    ],

    // === ERROR HANDLING ===
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Page not found: ${state.error}')),
    ),

    // === REDIRECTION (ROUTE GUARDS) ===
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authService.isLoggedIn; // Check auth status
      final bool loggingIn = state.matchedLocation == AppRoutes.login;

      // Define routes that require authentication
      final protectedRoutes = [AppRoutes.home, AppRoutes.settings]; // Add protected routes here
      final isProtectedRoute = protectedRoutes.contains(state.matchedLocation);

      print('Current location: ${state.matchedLocation}, Logged In: $loggedIn');

      // If not logged in and trying to access a protected route, redirect to login
      if (!loggedIn && isProtectedRoute) {
        print('Redirecting to login');
        return AppRoutes.login;
      }

      // If logged in and trying to access login page, redirect to home
      if (loggedIn && loggingIn) {
        print('Redirecting to home');
        return AppRoutes.home;
      }

      // No redirection needed
      print('No redirection needed');
      return null;
    },
  );
}

// Define route paths centrally
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String settings = '/settings';
  // Add other route paths here
}

// Example: Feature-specific route definitions (to be aggregated)
// class AuthRoutes {
//   static const String login = '/login';
//   static final routes = [
//     GoRoute(
//       path: login,
//       builder: (context, state) => const LoginPage(),
//     ),
//   ];
// }

