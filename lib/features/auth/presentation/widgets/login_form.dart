import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core_ui/core_ui.dart'; // Import the shared UI package
import '../bloc/auth_bloc.dart';
import '../../../../shared/utils/validator_utils.dart'; // Keep validator for now

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginSubmitted(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: ValidatorUtils.email,
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              obscureText: true,
              validator: ValidatorUtils.password,
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthBloc, AuthState>( // Rebuild button on AuthLoading state
              builder: (context, state) {
                final isLoading = state is AuthLoading;
                return PrimaryButton(
                  text: 'Login',
                  onPressed: isLoading ? null : _submitLogin,
                  isLoading: isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
