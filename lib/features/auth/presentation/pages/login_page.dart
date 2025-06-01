import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart'; // For getIt
import '../bloc/auth_bloc.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(), // Resolve AuthBloc via GetIt
      child: Scaffold(
        appBar: AppBar(title: const Text('Login Page')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('Login Successful! User: ${state.user.email}'),
                  backgroundColor: Colors.green,
                ));
              // TODO: Navigate to home page or dashboard
              // Navigator.of(context).pushReplacementNamed('/home');
              print("Authenticated! User: ${state.user.id}");
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('Login Failed: ${state.message}'),
                  backgroundColor: Colors.red,
                ));
            }
          },
          builder: (context, state) {
            // Can show a global loading indicator here based on state if needed
            // if (state is AuthLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            return const Center(
              child: SingleChildScrollView(
                child: LoginForm(),
              ),
            );
          },
        ),
      ),
    );
  }
}
