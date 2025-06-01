# Shared Layer

This directory contains reusable code and resources that are shared across multiple features or the entire application.

## Subdirectories:

-   **/constants**: Application-wide constants (e.g., API keys, default values, route names).
-   **/extensions**: Dart extension methods on existing classes to provide syntactic sugar or utility functionalities.
-   **/themes**: Theme definitions, color palettes, typography, and other styling resources.
-   **/utils**: Common utility functions and helper classes (e.g., validators, formatters, device info).
-   **/widgets**: Reusable UI components (e.g., custom buttons, form fields, dialogs, list items).

## How to Contribute:

-   **Identify Reusability**: Before adding code here, ensure it's genuinely applicable to more than one feature or is a core part of the application's look and feel.
-   **Generality**: Keep shared components as generic as possible. Avoid feature-specific logic.
-   **Documentation**: Add clear comments and, if necessary, usage examples for new shared widgets or complex utilities.
-   **No Feature Dependencies**: Shared code should NOT depend on any specific feature module (`lib/features/*`).
-   **Core Dependencies Only**: Shared code may depend on `lib/core/` if necessary (e.g., for core error types or DI for services used by shared widgets, though this should be rare for widgets).
-   **Testing**: Add unit tests for utilities and extensions. Add widget tests for shared widgets.
-   **Naming Conventions**: Follow established naming conventions.

When adding a new shared resource:
1.  Place it in the appropriate subdirectory.
2.  If it's a widget, ensure it has a clear API and is well-documented.
3.  If it's a utility, ensure it's pure and testable.
4.  Consider if it could benefit from being configurable (e.g., theming for widgets).
