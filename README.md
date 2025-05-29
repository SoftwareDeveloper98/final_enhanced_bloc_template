# Flutter Clean Architecture BLoC Template

This project serves as a production-ready starting point for Flutter applications built using Clean Architecture principles and the BLoC pattern for state management. It includes comprehensive setup for dependency injection, routing, networking, local storage, error handling, localization, theme management, testing, build flavors, feature flagging, performance monitoring, accessibility, and strict linting.

## Table of Contents

-   [Features](#features)
-   [Architecture](#architecture)
-   [Directory Structure](#directory-structure)
-   [Getting Started](#getting-started)
    -   [Prerequisites](#prerequisites)
    -   [Installation](#installation)
    -   [Running the App](#running-the-app)
    -   [Build Flavors](#build-flavors)
-   [Key Components](#key-components)
    -   [State Management (BLoC/Cubit)](#state-management-bloc-cubit)
    -   [Dependency Injection (GetIt + Injectable)](#dependency-injection-getit-injectable)
    -   [Routing (GoRouter)](#routing-gorouter)
    -   [Networking (Dio)](#networking-dio)
    -   [Local Storage (Hive)](#local-storage-hive)
    -   [Code Generation (Freezed, Build Runner)](#code-generation-freezed-build-runner)
    -   [Localization](#localization)
    -   [Theme Management](#theme-management)
    -   [Error Handling](#error-handling)
    -   [Logging](#logging)
    -   [Feature Flagging](#feature-flagging)
    -   [Performance Monitoring](#performance-monitoring)
    -   [Accessibility](#accessibility)
    -   [Linting](#linting)
-   [Testing](#testing)
    -   [Unit Tests](#unit-tests)
    -   [Widget Tests](#widget-tests)
    -   [Integration Tests](#integration-tests)
    -   [Code Coverage](#code-coverage)
-   [Adding a New Feature](#adding-a-new-feature)
-   [Large-Scale Application Features](#large-scale-application-features)
-   [Customization](#customization)
-   [Contributing](#contributing)
-   [License](#license)

## Features

-   **Clean Architecture:** Separation of concerns into Data, Domain, and Presentation layers.
-   **State Management:** Demonstrates both BLoC and Cubit patterns (`flutter_bloc`) with advanced patterns like `bloc_concurrency` and Bloc-to-Bloc communication.
-   **Dependency Injection:** Uses `get_it` and `injectable` for managing dependencies with environment-specific configurations.
-   **Routing:** Implements `go_router` for declarative routing with nested routes, route guards, and deep linking support.
-   **Networking:** Configured `dio` client with comprehensive interceptors for authentication, logging, error mapping, and retry logic.
-   **Local Storage:** Uses `hive` for efficient local data persistence.
-   **Code Generation:** Leverages `freezed` for immutable models/states and `build_runner` for DI and model generation.
-   **Localization:** Supports multiple languages using `flutter_localizations` and `.arb` files.
-   **Theme Management:** Dynamic light/dark theme switching using a Cubit.
-   **Error Handling:** Defined `Failure` and `Exception` classes for consistent error management with end-to-end error flow.
-   **Logging:** Integrated robust logging framework throughout the app with configurable levels.
-   **Testing:** Comprehensive examples for unit, widget, and integration tests with code coverage reporting.
-   **Build Flavors:** Implementation for different environments (dev/staging/prod) with environment-specific settings.
-   **Feature Flagging:** Basic feature flagging mechanism for enabling/disabling features across environments.
-   **Performance Monitoring:** Integration points for performance monitoring and tracking.
-   **Accessibility:** Guidelines and utilities for implementing accessibility best practices.
-   **Linting:** Strict linting rules configured using `flutter_lints`.
-   **Example Feature:** Includes a sample feature (`home`) demonstrating the architecture and state management.

## Architecture

This template follows the principles of Clean Architecture, dividing the application into three main layers:

1.  **Presentation Layer:** Contains UI elements (Widgets, Pages/Screens) and state management logic (BLoC/Cubit). It depends only on the Domain layer.
2.  **Domain Layer:** Contains business logic (Use Cases) and entity definitions. It defines repository interfaces that the Data layer implements. This layer has no dependencies on other layers.
3.  **Data Layer:** Contains repository implementations, data sources (remote and local), and data models (DTOs). It depends on the Domain layer (for interfaces) and external sources (network, database).

Core functionalities like routing, DI, theme, localization, etc., are organized in a structured manner:
- `lib/core/common/` contains shared utilities and base classes
- `lib/core/infrastructure/` contains implementation of core services
- `lib/core/config/` contains environment and feature configuration
- `lib/core/monitoring/` contains performance and analytics tools
- `lib/core/accessibility/` contains accessibility utilities and guidelines

## Directory Structure

```
lib/
├── app/
│   ├── di/                 # Dependency Injection (GetIt, Injectable)
│   ├── router/             # Routing (GoRouter)
│   └── view/               # Main App Widget
├── core/
│   ├── accessibility/      # Accessibility utilities and guidelines
│   ├── common/
│   │   ├── error/          # Failure & Exception classes
│   │   ├── logging/        # Logging module
│   │   └── usecases/       # Base UseCase class
│   ├── config/
│   │   ├── build_config.dart  # Environment configuration
│   │   └── feature_flags.dart # Feature flagging mechanism
│   ├── infrastructure/
│   │   ├── network/        # Networking setup (Dio)
│   │   ├── storage/        # Local Storage (Hive)
│   │   └── theme/          # Theme definitions & Cubit
│   ├── monitoring/
│   │   └── performance_monitor.dart # Performance tracking
│   └── translations/       # Localization files (.arb, generated)
│       └── l10n/
├── features/               # Feature-specific modules
│   └── home/               # Example feature
│       ├── data/
│       │   ├── datasources/  # Local/Remote data sources
│       │   ├── models/       # Data Transfer Objects (DTOs)
│       │   └── repositories/ # Repository implementation
│       ├── domain/
│       │   ├── entities/     # Business objects (Freezed)
│       │   ├── repositories/ # Repository interfaces
│       │   └── usecases/     # Feature-specific use cases
│       └── presentation/
│           ├── bloc/         # BLoC/Cubit logic
│           ├── pages/        # Screens/Pages
│           └── widgets/      # Reusable UI components for this feature
├── main.dart               # Default entry point
├── main_dev.dart           # Entry point for Development
├── main_prod.dart          # Entry point for Production
└── main_common.dart        # Common setup logic for main entry points

integration_test/          # Integration tests
test/                      # Unit and widget tests
l10n.yaml                  # Localization configuration
analysis_options.yaml      # Linting rules
build.yaml                 # Build runner configuration
pubspec.yaml               # Project dependencies
README.md                  # This file
```

## Getting Started

### Prerequisites

-   Flutter SDK (Check `.flutter-version` or `pubspec.yaml` for recommended version)
-   Dart SDK (Comes with Flutter)
-   An IDE like VS Code or Android Studio with Flutter plugins.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd <project-directory>
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run code generation:**
    This is necessary for `injectable`, `freezed`, and localization.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
    *Note: You might need to run this command again after adding new injectable classes, freezed models, or modifying `.arb` files.*

### Running the App

You can run the app using different entry points for development, staging, or production environments.

-   **Run in Development Mode:**
    ```bash
    flutter run -t lib/main_dev.dart
    ```
-   **Run in Production Mode:**
    ```bash
    flutter run -t lib/main_prod.dart
    ```
-   **Run with Default Configuration:**
    ```bash
    flutter run
    ```

### Build Flavors

The template supports different build flavors for various environments:

-   **Development:** Used during active development with debugging tools enabled.
    ```bash
    flutter run --flavor dev -t lib/main_dev.dart
    ```
-   **Staging:** Used for testing in a production-like environment.
    ```bash
    flutter run --flavor staging -t lib/main_staging.dart
    ```
-   **Production:** Used for release builds.
    ```bash
    flutter run --flavor prod -t lib/main_prod.dart
    ```

Each flavor can have its own configuration defined in `lib/core/config/build_config.dart`. The configuration includes:
- API base URL
- Logging settings
- Crash reporting settings
- Performance monitoring settings
- API keys

To use build flavors, you need to configure them in your `android/app/build.gradle` and `ios/Runner.xcodeproj` files.

## Key Components

### State Management (BLoC/Cubit)

-   Uses `flutter_bloc` for state management.
-   The `home` feature demonstrates `HomeBloc` for fetching data.
-   The `ThemeCubit` in `lib/core/infrastructure/theme/` demonstrates Cubit usage for managing theme state.
-   Uses `bloc_concurrency` (e.g., `droppable()`) in `HomeBloc` to handle event processing strategies.
-   Demonstrates Bloc-to-Bloc communication patterns for coordinating between different parts of the app.
-   Optionally supports `HydratedBloc` for persisting and restoring state.

### Dependency Injection (GetIt + Injectable)

-   `get_it` service locator is used.
-   `injectable` package automates `get_it` registration using annotations (`@injectable`, `@lazySingleton`, `@singleton`, `@module`, etc.).
-   Configuration is in `lib/app/di/injector.dart`.
-   Run `build_runner` to generate `injector.config.dart`.
-   Dependencies are registered based on annotations in their respective classes.
-   Supports environment-specific dependency registration using `@Environment('dev')`, `@Environment('prod')`, etc.
-   Features can register their own dependencies through modular registration patterns.

### Routing (GoRouter)

-   Uses `go_router` for declarative, URL-based navigation.
-   Configuration is in `lib/app/router/app_router.dart`.
-   Defines routes and maps them to specific pages/screens.
-   Supports nested routing for complex navigation hierarchies.
-   Implements route guards for authentication and authorization.
-   Handles deep linking for external app launches.
-   Supports type-safe route parameters.
-   Features can define their internal routes which are aggregated by the main router.

### Networking (Dio)

-   Uses `dio` for HTTP requests.
-   Base client configuration (base URL, timeouts, headers) is set up in `lib/core/infrastructure/network/dio_client.dart`.
-   Includes comprehensive interceptors:
  - Authentication interceptor for handling tokens
  - Logging interceptor for debugging
  - Error mapping interceptor for consistent error handling
  - Retry interceptor for handling transient failures
-   The `Dio` instance is registered with `injectable` for easy injection into repositories or data sources.

### Local Storage (Hive)

-   Uses `hive` and `hive_flutter` for fast, key-value based local storage.
-   Initialization and box opening are handled asynchronously within an `@module` (`lib/core/infrastructure/storage/hive_service.dart`) using `@preResolve`.
-   A basic `CacheManager` wrapper provides convenient methods for accessing a settings box.
-   Remember to register any custom `TypeAdapter`s within the `hive()` setup method in `StorageModule`.

### Code Generation (Freezed, Build Runner)

-   `freezed` is used to generate immutable data classes (entities, states) and handle boilerplate like `copyWith`, `==`, `hashCode`, and `toString`.
-   `json_serializable` (used with `freezed`) generates code for JSON serialization/deserialization.
-   `injectable_generator` generates dependency injection code.
-   `build_runner` orchestrates these code generation steps.
-   Configuration for builders is in `build.yaml`.

### Localization

-   Uses `flutter_localizations` and the `intl` package.
-   Configuration is in `l10n.yaml`.
-   String resources are defined in `.arb` files within `lib/core/translations/l10n/` (e.g., `app_en.arb`).
-   Run `flutter gen-l10n` to generate the `AppLocalizations` class.
-   Integrated into `MaterialApp.router` in `lib/app/view/app.dart`.
-   Access localized strings in widgets using `AppLocalizations.of(context)!.yourStringKey`.

### Theme Management

-   Provides `AppTheme` class (`lib/core/infrastructure/theme/app_theme.dart`) defining light and dark `ThemeData`.
-   Uses `ThemeCubit` (`lib/core/infrastructure/theme/theme_cubit.dart`) to manage the current `ThemeMode`.
-   The `ThemeCubit` is provided globally using `BlocProvider` in `lib/app/view/app.dart`.
-   `MaterialApp.router` uses the state from `ThemeCubit` to set the active theme.

### Error Handling

-   Defines a base `Failure` class (`lib/core/common/error/failures.dart`) representing domain/use case level errors.
-   Defines specific `Exception` classes (`lib/core/common/error/exceptions.dart`) for data layer errors (e.g., `ServerException`, `CacheException`).
-   Implements full end-to-end error flow:
  - Data layer catches exceptions and converts them to failures
  - Domain layer propagates failures through Either type
  - Presentation layer handles failures and updates UI accordingly
-   Repositories catch specific exceptions and return `Either<Failure, SuccessType>`.
-   Use cases propagate the `Either` type.
-   BLoCs/Cubits handle the `Either` result to update the UI state (e.g., `HomeError` state).

### Logging

-   Integrates a robust logging framework (`logger` package) throughout the app.
-   Logging module is defined in `lib/core/common/logging/logging_module.dart`.
-   Configurable log levels based on environment (verbose in dev, error-only in prod).
-   Demonstrates proper error and event logging throughout the application.
-   Can be extended to send logs to remote services in production.

### Feature Flagging

-   Implements a basic feature flagging mechanism in `lib/core/config/feature_flags.dart`.
-   Allows enabling/disabling features based on environment.
-   Supports remote configuration updates.
-   Provides a convenient context extension for checking feature availability.
-   Useful for A/B testing, gradual rollouts, and experimental features.

### Performance Monitoring

-   Provides integration points for performance monitoring in `lib/core/monitoring/performance_monitor.dart`.
-   Tracks operation durations, frame build times, and custom metrics.
-   Monitors UI performance with frame timing callbacks.
-   Includes a widget wrapper for monitoring specific UI components.
-   Can be extended to integrate with external monitoring services.

### Accessibility

-   Provides accessibility utilities and guidelines in `lib/core/accessibility/accessibility_utils.dart`.
-   Includes extensions for adding semantic labels and hints to widgets.
-   Demonstrates proper contrast, touch target sizes, and screen reader support.
-   Provides example implementations of accessible widgets.
-   Includes integration test for verifying accessibility features.

### Linting

-   Uses `package:flutter_lints/flutter.yaml` as a base.
-   Additional strict rules are enabled in `analysis_options.yaml` to enforce code quality and consistency.
-   Enforces consistent code style and best practices.

## Testing

The template includes comprehensive testing examples at all levels:

### Unit Tests

-   Tests for BLoCs/Cubits using `bloc_test`:
    -   Verifies state transitions
    -   Tests event handling
    -   Checks error handling
    -   Tests bloc_concurrency behavior
-   Tests for Use Cases:
    -   Verifies business logic
    -   Tests success and failure scenarios
    -   Ensures proper repository interaction
-   Tests for Repositories using `mockito`:
    -   Verifies data source interaction
    -   Tests error handling and mapping
    -   Ensures proper data transformation

Example unit tests can be found in:
- `test/features/home/domain/usecases/get_items_test.dart`
- `test/features/home/presentation/bloc/home_bloc_test.dart`

### Widget Tests

-   Tests for individual UI components:
    -   Verifies widget rendering
    -   Tests user interactions
    -   Checks state-dependent UI changes
-   Tests for complete screens:
    -   Verifies screen layout
    -   Tests navigation
    -   Checks integration with BLoCs/Cubits

Example widget tests can be found in:
- `test/features/home/presentation/pages/home_page_test.dart`

### Integration Tests

-   Tests for complete user flows:
    -   Verifies end-to-end functionality
    -   Tests real data fetching and rendering
    -   Checks navigation between screens
    -   Verifies accessibility features

Example integration tests can be found in:
- `integration_test/app_test.dart`

### Code Coverage

-   Set up to generate code coverage reports:
    ```bash
    flutter test --coverage
    genhtml coverage/lcov.info -o coverage/html
    ```
-   View the coverage report in `coverage/html/index.html`
-   Aim for high test coverage, especially for business logic

## Adding a New Feature

1.  **Create Feature Directory:** Create a new directory under `lib/features/your_feature_name/`.
2.  **Define Layers:** Create `data`, `domain`, and `presentation` subdirectories.
3.  **Domain Layer:**
    -   Define Entities (`lib/features/your_feature_name/domain/entities/`). Use `freezed`.
    -   Define Repository Interface (`lib/features/your_feature_name/domain/repositories/`).
    -   Implement Use Cases (`lib/features/your_feature_name/domain/usecases/`). Annotate with `@lazySingleton`.
4.  **Data Layer:**
    -   Implement Data Sources (Local/Remote) (`lib/features/your_feature_name/data/datasources/`). Annotate with `@LazySingleton(as: YourDataSourceInterface)`.
    -   Implement Repository (`lib/features/your_feature_name/data/repositories/`). Annotate with `@LazySingleton(as: YourRepositoryInterface)` and inject data sources.
5.  **Presentation Layer:**
    -   Implement BLoC/Cubit (`lib/features/your_feature_name/presentation/bloc/`). Annotate with `@injectable` and inject use cases.
    -   Define States and Events (often using `freezed`).
    -   Create Pages/Screens (`lib/features/your_feature_name/presentation/pages/`).
    -   Create Widgets (`lib/features/your_feature_name/presentation/widgets/`).
6.  **Routing:** Add a new route in `lib/app/router/app_router.dart` or create a feature-specific router that's aggregated by the main router.
7.  **Dependency Injection:** Ensure all new injectable classes (`@lazySingleton`, `@injectable`, etc.) are annotated correctly.
8.  **Run Code Generation:** `flutter pub run build_runner build --delete-conflicting-outputs`.
9.  **UI Integration:** Use `BlocProvider` to provide your BLoC/Cubit and `BlocBuilder`/`BlocListener` to react to state changes in your UI.
10. **Testing:** Add unit, widget, and integration tests for your new feature.

## Large-Scale Application Features

The template includes several features specifically designed for large-scale applications:

### Feature Flagging

Feature flags allow you to enable or disable specific features based on environment or remote configuration:

```dart
// Check if a feature is enabled
if (FeatureFlags.instance.isEnabled('experimental_ui')) {
  // Show experimental UI
}

// Using the context extension
if (context.isFeatureEnabled('premium_features')) {
  // Show premium features
}
```

### Performance Monitoring

Track performance metrics throughout your application:

```dart
// Start timing an operation
PerformanceMonitor.instance.startOperation('data_loading');

// End timing and log the duration
PerformanceMonitor.instance.endOperation('data_loading');

// Track a custom metric
PerformanceMonitor.instance.trackMetric('items_count', items.length);

// Wrap a widget for performance monitoring
PerformanceMonitorWidget(
  widgetName: 'ItemList',
  child: YourWidget(),
)
```

### Accessibility

Improve app accessibility with provided utilities:

```dart
// Add semantic label to a widget
IconButton(
  icon: Icon(Icons.refresh),
  onPressed: () {},
).withSemanticLabel('Refresh data');

// Ensure minimum touch target size
IconButton(
  icon: Icon(Icons.settings),
  onPressed: () {},
).withMinimumTouchSize();

// Create accessible text
Text('Hello World').withAccessibleText();
```

### Environment-Specific Configuration

Access environment-specific configuration:

```dart
// Get the API base URL for the current environment
final apiBaseUrl = BuildConfig.instance.apiBaseUrl;

// Check if we're in development mode
if (BuildConfig.instance.isDev) {
  // Enable additional logging
}

// Access API keys (masked in logs in production)
final apiKey = BuildConfig.instance.apiKey;
```

## Customization

-   **Base URL:** Update the `baseUrl` in `lib/core/infrastructure/network/dio_client.dart` or use environment-specific URLs in `BuildConfig`.
-   **Themes:** Modify `ThemeData` in `lib/core/infrastructure/theme/app_theme.dart`.
-   **Localization:** Add new `.arb` files for other languages in `lib/core/translations/l10n/` and update `supportedLocales` in `lib/app/view/app.dart` if needed.
-   **Lint Rules:** Adjust rules in `analysis_options.yaml`.
-   **Dependencies:** Add or remove packages in `pubspec.yaml`.
-   **Environment Configuration:** Customize environment settings in `lib/core/config/build_config.dart` and initialize in the appropriate `main_*.dart` files.
-   **Feature Flags:** Add or modify feature flags in `lib/core/config/feature_flags.dart`.

## Contributing

Contributions are welcome! Please follow standard Gitflow practices and ensure code adheres to the established architecture and linting rules.

## License

This project is licensed under the MIT License - see the LICENSE file for details (if applicable).
