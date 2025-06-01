# Auth Feature Module

This module handles all authentication-related functionalities, including user login, signup, logout, and session management.

## Structure:

-   **`data/`**: Contains data source implementations (remote and local) and repository implementations.
    -   `data_sources/`: Interfaces and implementations for fetching/storing auth data (e.g., `AuthRemoteDataSource`, `AuthLocalDataSource`).
    -   `models/`: Data Transfer Objects (DTOs) specific to the data layer (e.g., `UserModel`). Often extends domain entities.
    -   `repositories/`: Implementation of the `AuthRepository` interface defined in the domain layer.
-   **`domain/`**: Contains the core business logic and definitions for authentication.
    -   `entities/`: Business objects representing authentication concepts (e.g., `UserEntity`).
    -   `repositories/`: Abstract definitions (interfaces) for data operations required by the domain layer (e.g., `AuthRepository`).
    -   `use_cases/`: Individual business operations or user stories (e.g., `LoginUseCase`, `SignupUseCase`).
-   **`presentation/`**: Contains the UI and state management logic (BLoCs/Cubits).
    -   `bloc/` (or `cubit/`): BLoCs/Cubits responsible for managing the state of the auth screens (e.g., `AuthBloc`, `LoginBloc`). Includes events and states.
    -   `pages/` (or `screens/`): UI screens related to authentication (e.g., `LoginPage`, `SignupPage`).
    -   `widgets/`: Reusable UI components specific to this feature (e.g., `LoginForm`, `SocialLoginButton`).

## How to Add New Components:

-   **New BLoC/Cubit**:
    1.  Define events and states in `presentation/bloc/your_bloc_name_event.dart` and `presentation/bloc/your_bloc_name_state.dart`.
    2.  Create `presentation/bloc/your_bloc_name_bloc.dart` extending `BaseBloc`.
    3.  Implement `handleEvent` to call relevant use cases.
    4.  Register the BLoC in the DI setup if it needs to be accessed from multiple places or has dependencies.
-   **New Data Source**:
    1.  Define the interface in `data/data_sources/your_data_source.dart`.
    2.  Implement the interface, typically interacting with `NetworkService` (for remote) or local storage.
    3.  Register the data source in DI.
    4.  Update the repository implementation to use the new data source.
-   **New UI Page**:
    1.  Create the widget in `presentation/pages/your_page.dart`.
    2.  Use `BlocProvider` (if creating a new BLoC instance for the page) or `context.read<YourBloc>()` (if accessing an existing BLoC).
    3.  Use `BlocBuilder` and `BlocListener` to react to state changes.
    4.  Add routing for the new page in the app's router configuration.

## Dependencies:

- This feature module may depend on:
    - `lib/core/`
    - `lib/shared/`
    - External packages defined in `pubspec.yaml`.
- It should NOT depend directly on other feature modules. Inter-feature communication should happen via shared services, router, or global BLoCs if necessary.
