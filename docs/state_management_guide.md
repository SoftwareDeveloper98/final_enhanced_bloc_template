# State Management Guide (BLoC)

This document details the state management approach used in this project, which is centered around the **BLoC (Business Logic Component)** pattern. Our goal is to create a predictable, testable, and scalable way to manage state in the presentation layer.

## Why BLoC?

BLoC was chosen for several key reasons:
-   **Separation of Concerns:** It cleanly separates business logic from the UI. Widgets are responsible for rendering the UI and dispatching events, while the BLoC handles the logic and state changes.
-   **Testability:** By isolating business logic in BLoCs, we can test it independently of the UI, leading to more robust and reliable code.
-   **Predictability:** The flow of data is unidirectional and clear: UI events are dispatched to the BLoC, which emits states back to the UI. This makes the application's behavior easier to reason about.
-   **Scalability:** BLoC is well-suited for complex applications and scales well as new features are added.
-   **Rich Ecosystem:** The `flutter_bloc` package provides powerful tools like `BlocProvider`, `BlocBuilder`, `BlocListener`, and `BlocTest` that simplify development and testing.

## Core Concepts

The BLoC pattern has three main components:

1.  **Events:** These are the inputs to a BLoC. They are typically triggered by user interactions (like a button press) or other application events (like a lifecycle event). Events are simple, immutable classes that extend a base `AuthEvent` class.
    *   *Example (`auth_event.dart`):* `LoginSubmitted` is an event that carries the user's email and password.

2.  **States:** These are the outputs of a BLoC. They represent a part of your application's state and are used by the UI to render itself. States should be immutable to ensure predictability. A feature's state is typically modeled with a sealed class hierarchy.
    *   *Example (`auth_state.dart`):* `AuthInitial`, `AuthLoading`, `Authenticated`, and `AuthError` are all possible states for the authentication feature.

3.  **BLoC (Business Logic Component):** The BLoC is the intermediary that receives `Events`, processes them (often by calling a `UseCase` from the domain layer), and emits new `States`.
    *   *Example (`auth_bloc.dart`):* The `AuthBloc` listens for a `LoginSubmitted` event, calls the `LoginUseCase`, and depending on the success or failure result, emits an `Authenticated` or `AuthError` state.

## Data Flow

The data flow is unidirectional and follows these steps:
1.  A user interacts with a widget in the **UI**.
2.  The widget dispatches an **Event** to the **BLoC**.
3.  The **BLoC** receives the event, and may initially emit a `Loading` state.
4.  The **BLoC** calls the relevant **UseCase** from the domain layer.
5.  The **UseCase** executes business logic, gets data from the **Repository**, and returns a result (`Either<Failure, Data>`).
6.  The **BLoC** receives the result from the UseCase and, based on the outcome, emits a new **State** (e.g., `Success` with data or `Error` with a message).
7.  The **UI** listens for state changes and rebuilds itself to reflect the new state.

## Implementation in the UI

The `flutter_bloc` package provides widgets to interact with BLoCs.

-   **`BlocProvider`:** This widget provides a BLoC to its children in the widget tree. It's typically placed above the page or screen that needs access to the BLoC.
    ```dart
    // In login_page.dart
    BlocProvider(
      create: (context) => getIt<AuthBloc>(), // Resolve via GetIt
      child: Scaffold(...)
    )
    ```

-   **`BlocBuilder`:** This widget rebuilds its `builder` function in response to new states from the BLoC. It's used for parts of the UI that need to change based on the state.
    ```dart
    // In login_form.dart
    BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return PrimaryButton(
          text: 'Login',
          isLoading: isLoading,
          // ...
        );
      },
    )
    ```

-   **`BlocListener`:** This widget listens for state changes and performs a one-time action, such as showing a `SnackBar`, a dialog, or navigating to another screen. It does not rebuild the UI.
    ```dart
    // In login_page.dart
    listener: (context, state) {
      if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${state.message}'))
        );
      } else if (state is Authenticated) {
        // Navigate to home page
      }
    }
    ```

-   **`BlocConsumer`:** This widget combines the functionality of `BlocBuilder` and `BlocListener` into a single widget for convenience. The `LoginPage` uses this to both rebuild parts of the UI and show snackbars.

By following these patterns, we ensure our application's state is managed in a clean, scalable, and maintainable way. When creating a new feature, you should follow the structure laid out in the `auth` feature as a template.
