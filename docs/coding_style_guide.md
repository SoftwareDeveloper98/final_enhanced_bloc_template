# Coding Style Guide

This document outlines the coding style, formatting conventions, and best practices adopted for the Flutter Enterprise Scaffold App. Consistency in code style is crucial for readability, maintainability, and effective team collaboration.

## Core Principles
1.  **Effective Dart:** Adhere to the official [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines as the primary source for style, documentation, usage, and design.
2.  **Flutter Lints:** The project uses [`package:flutter_lints`](https://pub.dev/packages/flutter_lints) as a base for static analysis. The specific rules enabled and customized are defined in the root [`analysis_options.yaml`](../../analysis_options.yaml) file.
3.  **Readability:** Code should be written to be easily understood by other developers (and your future self).
4.  **Consistency:** Apply chosen styles and patterns consistently across the entire codebase.

## Formatting
-   **Automatic Formatting:** Use `dart format` for all Dart code. This is typically integrated into IDEs (on save) and checked by the CI pipeline (`dart format --output=none --set-exit-if-changed .`).
    -   Line Length: 80 characters (default for `dart format`).
-   **Bracket Placement:** Use Allman style (brackets on new lines) for control flow structures and declarations, which is the default for `dart format`.
-   **Trailing Commas:** Use trailing commas where appropriate (e.g., in argument lists, collection literals) to improve diff readability and allow easier reordering of items. `dart format` helps enforce this.

## Naming Conventions
-   **Classes, Enums, Typedefs, Extensions, Mixins:** `UpperCamelCase` (e.g., `MyClass`, `StatusEnum`, `UserProfileDto`).
-   **Methods, Functions, Variables, Parameters:** `lowerCamelCase` (e.g., `myFunction`, `userName`, `isEnabled`).
-   **Constants (compile-time constants):** `lowerCamelCase` or `kLowerCamelCase` (e.g., `defaultTimeout`, `kDefaultPadding`). Using `k` prefix for global/static constants is a common convention.
-   **Files:** `snake_case.dart` (e.g., `user_profile.dart`, `network_service.dart`).
-   **Packages (Local):** `snake_case` (e.g., `core_ui`, `feature_auth`).
-   **Boolean Variables/Getters:** Should generally be prefixed with `is`, `has`, `can`, `should`, etc. (e.g., `isLoading`, `hasConnection`, `canSubmit`).

## Imports
-   **Order:**
    1.  `dart:` imports
    2.  `package:` imports (Flutter framework, third-party packages)
    3.  Relative imports (`import '../'`, `import './'`) - **Avoid relative imports for files within `lib/`. Use package-prefixed imports instead** (e.g., `import 'package:my_app/features/auth/data/models/user_dto.dart';`). The `avoid_relative_lib_imports` lint helps enforce this.
-   **`show` and `as`:** Use `show` to import only necessary parts of a library. Use `as` to handle naming conflicts.
-   **Sorting:** Imports within each group should be sorted alphabetically. The `directives_ordering` lint helps with this.

## Comments and Documentation
-   **Dartdoc:** Use Dartdoc (`///`) for all public APIs (classes, methods, functions, top-level variables).
    -   Start with a concise single-sentence summary.
    -   Follow with more detailed paragraphs if necessary.
    -   Use markdown for formatting.
    -   Document parameters, return types, and exceptions thrown.
-   **Implementation Comments:** Use `//` for comments within method bodies or for private members if clarification is needed. Avoid obvious comments.
-   **TODOs:** Use `// TODO: Your Name - A brief description of what needs to be done.` or `// TODO(username): Description.` Include context or an issue tracker link if possible.

## Flutter Specifics
-   **`const` Constructors:** Use `const` for widget constructors whenever possible to improve performance by allowing Flutter to cache widget instances. The `prefer_const_constructors` and `prefer_const_declarations` lints help.
-   **`BuildContext`:** Avoid passing `BuildContext` to services or business logic classes. Handle context-dependent actions within the UI layer. Be mindful of `BuildContext` in `async` gaps (`use_build_context_synchronously` lint).
-   **Widget Structure:** Keep widget build methods small and focused. Extract complex parts into smaller, reusable widgets.
-   **`Key`s:** Use `Key`s in widget constructors, especially for lists of widgets of the same type or when needing to preserve state during widget reordering/rebuilding (`use_key_in_widget_constructors` lint).
-   **`SizedBox` for Spacing:** Prefer `const SizedBox(width: X, height: Y)` for adding whitespace between widgets over `Container` with padding/margin for purely spacing purposes (`sized_box_for_whitespace` lint).

## Asynchronous Code
-   **`async/await`:** Use `async/await` for clarity with `Future`s.
-   **Error Handling:** Properly handle errors in asynchronous operations using `try-catch` or `Future.catchError`.
-   **`FutureOr<T>`:** Use `FutureOr<T>` for parameters or return types that can be either `T` or `Future<T>`.

## State Management (e.g., BLoC/Cubit)
-   (This section would be more detailed based on the chosen state management solution)
-   **Events/States:** Define events and states clearly and immutably.
-   **Side Effects:** Handle side effects (API calls, database access) within BLoCs/Cubits, often triggered by events and resulting in new states.
-   **UI Interaction:** UI widgets should dispatch events to BLoCs/Cubits and listen to state changes to rebuild.

## General Best Practices
-   **Immutability:** Prefer immutable data structures where possible, especially for state objects and entities.
-   **Single Responsibility Principle (SRP):** Classes and methods should have one primary responsibility.
-   **DRY (Don't Repeat Yourself):** Avoid code duplication by extracting common logic into reusable functions or classes.
-   **Error Handling:** Implement robust error handling. Use custom exceptions for domain-specific errors.
-   **Logging:** Use the application's `LoggerService` for logging instead of `print()`.
-   **Type Safety:** Leverage Dart's strong type system. Avoid `dynamic` where a more specific type is known.

## Analysis Options
The root [`analysis_options.yaml`](../../analysis_options.yaml) file is the source of truth for enabled linter rules and analyzer settings. All developers should ensure their IDE uses these settings.

By adhering to this style guide, we aim to produce a codebase that is clean, consistent, and easy for all team members to work with. This guide is a living document and may be updated as the project evolves and new best practices emerge.
