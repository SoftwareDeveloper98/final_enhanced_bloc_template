import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add if Bloc is used early
import 'core/di/service_locator.dart';
import 'features/auth/presentation/pages/login_page.dart'; // Import LoginPage
import 'shared/themes/app_theme.dart'; // Import AppTheme

// Dummy App widget for now
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Enterprise Scaffold',
      theme: AppTheme.lightTheme, // Example from shared
      darkTheme: AppTheme.darkTheme, // Example from shared
      // themeMode: ThemeMode.system, // Or from a theme cubit
      home: const LoginPage(), // Set LoginPage as home for now
    );
  }
}

Future<void> mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(environment: environment);
  // runApp(const MyApp());
  // More setup here, like Bloc observers, etc.
   runApp(const MyApp()); // Temporary, replace with actual App widget
}
