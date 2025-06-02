import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart'; // Depends on core_ui

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Perform login logic
      final email = _emailController.text;
      final password = _passwordController.text;
      print('Login attempt: Email=$email, Password=****');
      // In a real app, you would call a BLoC/Cubit event or a UseCase:
      // context.read<AuthBloc>().add(LoginRequested(email, password));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in with $email... (Placeholder)')),
      );
      // Example of navigating away or showing success/failure
      // Navigator.of(context).pop(); // Example: go back after "login"
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Login'), // Using CustomAppBar from core_ui
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'you@example.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                onPressed: _handleLogin,
                child: const Text('Login Now'),
              ),
              TextButton(
                onPressed: () {
                  // Handle navigation to registration or forgot password
                  print('Navigate to Register/Forgot Password (Placeholder)');
                },
                child: const Text('Forgot password? / Sign up'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
