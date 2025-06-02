import 'package:flutter/material.dart';
import 'package:feature_auth/feature_auth.dart'; // Import from the local package

// Assuming DI and other setup is done elsewhere (e.g. main_common.dart via main_dev.dart)
// For this example, keep it simple to demonstrate package linking.
// In a real app, main() would likely call a function in main_common.dart
// which in turn calls configureDependencies() and then runApp().

void main() {
  // Example: If you had a common DI setup, it might be called here or in a main_env.dart file
  // WidgetsFlutterBinding.ensureInitialized();
  // await configureDependencies('dev'); // Your DI setup from app_injector.dart
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multi-Module Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Changed primary swatch for a bit of style
        useMaterial3: true,
        // Example of using a font from a shared UI package if you had one
        // fontFamily: core_ui.CoreFonts.primary,
      ),
      home: const MainScreen(), // Entry point of the app shell
      // For a real app, you'd use a proper router here:
      // routerConfig: sl<AppRouter>().config(), // Example with GoRouter and GetIt
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Shell - Main Screen'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the main application shell.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const LoginScreen(), // Navigate to LoginScreen from feature_auth
                ));
              },
              child: const Text('Go to Login (from Auth Feature)'),
            ),
          ],
        ),
      ),
    );
  }
}
