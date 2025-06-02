# Root Pubspec.yaml Modifications for Monorepo Setup

To integrate the local packages (`core_ui`, `feature_auth`, etc.) from the `packages/` directory into the main application (the Flutter app at the root of this monorepo), and to use Melos for managing the monorepo, the following changes are needed in the main `pubspec.yaml` file located at the root of the project.

**This tool cannot directly modify the root `pubspec.yaml`. Please apply these changes manually.**

```yaml
name: my_app # Or your actual root application name (e.g., my_flutter_enterprise_app)
description: The main Flutter application shell.
# publish_to: 'none' # Recommended if the app shell itself is not a library to be published

# Ensure your environment SDK constraints are appropriate
environment:
  sdk: '>=3.0.0 <4.0.0' # Adjust to your project's Flutter SDK constraint

dependencies:
  flutter:
    sdk: flutter

  # Add any other global dependencies your app shell needs, for example:
  # get_it: ^7.6.0
  # flutter_bloc: ^8.1.3
  # dartz: ^0.10.1
  # intl: ^0.18.1 # For AppLocalizations if using flutter gen-l10n at the root
  # go_router: ^10.0.0 # Or your preferred routing package

  # --- Local Package Dependencies ---
  # These path dependencies link your app shell to the local packages
  # defined in the `packages/` directory. Melos will help manage these,
  # especially with the `usePubspecOverrides: true` option in `melos.yaml`,
  # which creates `pubspec_overrides.yaml` files to ensure correct resolution.

  core_ui:
    path: packages/core_ui

  feature_auth:
    path: packages/feature_auth

  # Add other local feature or utility packages here as you create them:
  # feature_home:
  #   path: packages/feature_home
  # core_networking:
  #   path: packages/core_networking
  # ...

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Integration tests if you have them at the root app level
  # integration_test:
  #   sdk: flutter

  # Melos is a dev dependency for managing the monorepo.
  # Ensure this version is compatible with your Dart/Flutter SDK.
  # You can update to the latest stable version of Melos.
  melos: ^3.1.1 # Or a more recent version like ^4.0.0 or ^5.0.0

  # flutter_lints is highly recommended for static analysis.
  flutter_lints: ^3.0.0 # Or your preferred version

  # build_runner is needed if your app shell or any local package uses code generation.
  # build_runner: ^2.4.0
  # If the app shell itself generates code (e.g., for DI, routing):
  # injectable_generator: ^2.1.0
  # go_router_builder: ^7.0.0

# Flutter specific configurations
flutter:
  uses-material-design: true

  # If your app shell has its own assets (separate from local packages)
  # assets:
  #   - assets/images/shell/
  #   - assets/translations/shell/

  # If your app shell defines fonts
  # fonts:
  #   - family: MyCustomFont
  #     fonts:
  #       - asset: assets/fonts/MyCustomFont-Regular.ttf
  #       - asset: assets/fonts/MyCustomFont-Bold.ttf
  #         weight: 700
```

**After making these changes:**

1.  **Install Melos (if not already installed globally, or use via Dart):**
    *   Globally: `dart pub global activate melos`
    *   Per project (recommended for CI and team consistency):
        You can run Melos commands using `dart run melos <command>` if you have it in `dev_dependencies`.
        Or, if you've activated it globally, just `melos <command>`.

2.  **Bootstrap the workspace:**
    Run `melos bootstrap` (or `dart run melos bootstrap`) in the root directory. This will:
    *   Install dependencies for all packages (including the root app and those in `packages/`).
    *   Create `pubspec_overrides.yaml` files in packages that have local path dependencies, ensuring the Dart analyzer and build tools correctly resolve these local packages.

This setup allows you to manage your multi-package Flutter project efficiently. You can run commands like `melos run analyze_all`, `melos run test_all`, etc., from the root to operate on all packages simultaneously.
