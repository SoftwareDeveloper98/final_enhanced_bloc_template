# Testing Strategy

This document outlines the testing strategy for the Flutter Enterprise Scaffold App. A comprehensive testing approach is crucial for ensuring code quality, preventing regressions, and enabling confident refactoring and feature development.

## Core Principles
-   **Test Pyramid:** We aim to follow the principles of the testing pyramid:
    -   A large base of **Unit Tests**.
    -   A moderate number of **Widget Tests**.
    -   Fewer, but critical, **Integration Tests**.
    -   (Optionally) A small number of End-to-End (E2E) tests for critical user flows if deemed necessary.
-   **Automation:** All tests should be automated and runnable via a single command (e.g., `melos run test_all`). They are a core part of the CI/CD pipeline.
-   **Test Coverage:** While aiming for high coverage, the focus is on testing critical paths and complex logic effectively rather than just chasing a percentage. Tools like `flutter test --coverage` are used to generate reports.
-   **Isolation:** Tests should be isolated and independent of each other. Unit tests, in particular, should not rely on external systems or a running Flutter engine where possible.
-   **Readability & Maintainability:** Test code is as important as production code. It should be clear, concise, and easy to maintain.

## Types of Tests

### 1. Unit Tests
-   **Purpose:** To test individual functions, methods, or classes in isolation. They verify the correctness of business logic within Use Cases, BLoCs/Cubits, Mappers, Validators, and utility functions.
-   **Location:** Typically within the `test/` directory of the specific package or feature module, mirroring the structure of `lib/`.
    -   Example: `packages/feature_auth/test/domain/usecases/login_usecase_test.dart`
-   **Key Characteristics:**
    *   Fast to execute.
    *   No Flutter framework dependencies (pure Dart tests where possible).
    *   Dependencies are mocked using packages like `mocktail`.
-   **Tools:**
    *   `package:test` (Dart's built-in testing framework).
    *   `package:mocktail` (for creating mock objects).
    *   `package:bloc_test` (for testing BLoCs/Cubits).
    *   `package:dartz` (if using `Either` for functional error handling, test both `Left` and `Right` cases).
-   **What to Test:**
    *   Logic within Use Cases.
    *   State changes and logic within BLoCs/Cubits based on events.
    *   Data transformations in Mappers.
    *   Validation logic.
    *   Edge cases, error conditions, and successful paths.

### 2. Widget Tests (Component Tests)
-   **Purpose:** To test individual Flutter Widgets in isolation. They verify that the widget's UI renders correctly, responds to user interactions as expected, and interacts correctly with its direct dependencies (which are often mocked).
-   **Location:** Also within the `test/` directory, often in a `presentation/widgets/` subdirectory.
    -   Example: `packages/core_ui/test/widgets/custom_app_bar_test.dart`
    -   Example: `packages/feature_auth/test/presentation/widgets/login_form_test.dart`
-   **Key Characteristics:**
    *   Run in a test environment with a Flutter framework instance.
    *   Faster than integration tests but slower than unit tests.
    *   Test a single widget's behavior, not entire screen flows.
-   **Tools:**
    *   `package:flutter_test` (Flutter's widget testing framework).
    *   `WidgetTester` for interacting with widgets (tapping, entering text, pumping frames).
    *   `find` API to locate widgets in the tree.
    *   `package:mocktail` for mocking dependencies (e.g., BLoCs/Cubits passed to the widget).
    *   `package:core_test_utils/core_test_utils.dart` (our shared test utilities package, e.g., for `pumpApp`).
-   **What to Test:**
    *   Correct rendering based on input parameters or state.
    *   UI changes in response to events or state updates (if testing with a mock BLoC).
    *   Callbacks being invoked upon user interaction (e.g., `onPressed`).
    *   Basic form validation and input handling at the widget level.

### 3. Integration Tests
-   **Purpose:** To test complete features, screen flows, or interactions between multiple components (widgets, BLoCs, services). They verify that different parts of the application work together correctly.
-   **Location:** In the `integration_test/` directory at the root of the main application package or within individual packages if testing package-specific flows. The example `integration_test/auth_flow_test.dart` is at the app root.
-   **Key Characteristics:**
    *   Run on a real device or emulator/simulator.
    *   Slower to execute as they involve launching parts of or the entire app.
    *   Can interact with real or mocked backend services (depending on the test scope). For CI, backends are usually mocked.
-   **Tools:**
    *   `package:integration_test` (Flutter's official integration testing framework).
    *   `package:flutter_test` (uses the same `WidgetTester` and `find` APIs as widget tests).
    *   `Patrol` (third-party) or `Flutter Driver` (older, less commonly used now) can be considered for more complex E2E needs or native interactions, but `integration_test` is the default.
    *   Mocked DI setup for services (e.g., configuring GetIt with mock repositories or services for integration tests).
-   **What to Test:**
    *   User flows (e.g., login process, completing a form, navigation between screens).
    *   Interactions between UI, state management, and services (with services typically mocked).
    *   Correct data display and updates across screens.
    *   Deep linking or navigation logic.

### 4. End-to-End (E2E) Tests (Optional/Future)
-   **Purpose:** To test the entire application flow from the user's perspective, often including real backend interactions.
-   **Considerations:**
    *   Most complex and slowest to run.
    *   Can be brittle and require significant maintenance.
    *   Provide the highest confidence that the whole system works.
-   **Strategy:** If implemented, focus on a few critical "happy path" scenarios. For most cases, thorough integration testing with mocked backends provides a good balance of confidence and reliability.
-   **Tools:** `Patrol` is a strong contender as it builds on `integration_test` and offers native interaction capabilities.

## Test Data and Mocks
-   **Data Generators:** Use functions or classes to generate consistent fake data for tests (e.g., `createFakeUserProfile()` in `core_test_utils`).
-   **Mocks:** Use `mocktail` to create mock implementations of dependencies.
    *   For BLoCs/Cubits in widget tests, you can mock their state stream.
    *   For Repositories in UseCase/BLoC unit tests, mock their methods to return `Either.Right` (success) or `Either.Left` (failure).
-   **Shared Test Utilities:** Place reusable test helpers, mocks, and data generators in the `packages/core_test_utils` package.

## Running Tests
-   **Locally:**
    *   From IDE: Most IDEs provide gutter icons to run individual tests or test files.
    *   From CLI:
        *   `flutter test <path_to_test_file.dart>`
        *   `flutter test` (runs all tests in the current package)
        *   `melos run test_all` (runs all tests in all packages in the monorepo)
        *   `flutter test integration_test` (for integration tests)
-   **CI/CD:** Tests are automatically run by the GitHub Actions workflow defined in `.github/workflows/ci.yaml`.

## Test Coverage
-   Generate coverage reports: `flutter test --coverage`
-   Analyze `coverage/lcov.info` using tools or IDE extensions.
-   Aim for meaningful coverage of business logic and critical UI interactions.

This testing strategy aims to build a robust and reliable application. It's a living document and should be adapted as the project evolves. All developers are responsible for writing tests for the code they produce.
