import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_app/features/auth/domain/entities/user_entity.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_app/features/auth/presentation/pages/login_page.dart';
import 'package:my_app/features/auth/presentation/widgets/login_form.dart';
import 'package:core_ui/core_ui.dart'; // For PrimaryButton

// Mock AuthBloc using bloc_test's MockBloc
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    // It's important to provide an initial state for the mock BLoC
    when(() => mockAuthBloc.state).thenReturn(const AuthInitial());
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  testWidgets('renders LoginForm', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(LoginForm), findsOneWidget);
  });

  testWidgets('shows loading indicator when state is AuthLoading', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthBloc.state).thenReturn(const AuthLoading());

    // Act
    await tester.pumpWidget(createWidgetUnderTest());

    // Assert
    // The PrimaryButton should now contain a CircularProgressIndicator
    final buttonFinder = find.byType(PrimaryButton);
    expect(buttonFinder, findsOneWidget);

    final PrimaryButton button = tester.widget(buttonFinder);
    expect(button.isLoading, isTrue);

    // Also check for the indicator itself
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows SnackBar with error message when state is AuthError', (WidgetTester tester) async {
    // Arrange
    const errorMessage = 'Invalid credentials';
    // Use a stream to emit the states for the BlocConsumer's listener
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([const AuthError(message: errorMessage)]),
      initialState: const AuthInitial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Pump once for the listener to react

    // Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Login Failed: $errorMessage'), findsOneWidget);
  });

   testWidgets('shows SnackBar with success message when state is Authenticated', (WidgetTester tester) async {
    // Arrange
    final tUser = UserEntity(id: '1', email: 'test@test.com', name: 'Test');
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([Authenticated(user: tUser)]),
      initialState: const AuthInitial(),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Pump once for the listener to react

    // Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Login Successful! User: ${tUser.email}'), findsOneWidget);
  });
}
