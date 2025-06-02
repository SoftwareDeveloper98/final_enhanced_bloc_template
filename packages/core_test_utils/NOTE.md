This package `core_test_utils` provides shared utilities for testing across the `my_app` Flutter project.

**Dependencies:**

1.  **Path Dependency `my_app`**:
    The `pubspec.yaml` includes a path dependency to `my_app`:
    ```yaml
    my_app:
      path: ../../
    ```
    This path is relative to `packages/core_test_utils/pubspec.yaml`. If your main application package (`my_app`) is located differently relative to the `packages` directory, you may need to adjust this path. For example, if `core_test_utils` was directly inside a `packages` folder at the root, and `my_app` (your main app code) is also at the root, `../../` should be correct.

2.  **`mocktail`**:
    `mocktail` is included as a direct dependency in `core_test_utils/pubspec.yaml`. Ensure the version (`^1.0.0` or your preferred version) is compatible with your project. This package will use `mocktail` for creating mock objects.

3.  **`flutter_bloc` (Optional)**:
    If your project uses `flutter_bloc` and you intend to add test helpers that involve BLoCs or Cubits (e.g., mocking them or providing them in `pump_app.dart`), you should uncomment and add `flutter_bloc` to the `dependencies` section of `packages/core_test_utils/pubspec.yaml`.
    ```yaml
    # flutter_bloc: ^8.1.3 # Adjust version as needed
    ```
    And also ensure `flutter_bloc` is a dependency in your main `my_app/pubspec.yaml`.

**Usage:**
After setting up the `pubspec.yaml` for `core_test_utils` and your main application's `pubspec.yaml` (if it needs to reference `core_test_utils` as a path dependency, though typically it's the other way around for test utilities), run `flutter pub get` in both the `my_app` root and potentially within `packages/core_test_utils` if you are developing the package in isolation (less common).

The utilities from this package (like `MockAuthRepository`, `createFakeUserProfile`, `pumpApp`) can then be imported into your test files (e.g., `my_app/test/.../some_test.dart`) using:
`import 'package:core_test_utils/core_test_utils.dart';`

**Important:**
This `core_test_utils` is intended to be a local package within your monorepo structure. The `publish_to: 'none'` line in its `pubspec.yaml` prevents it from being accidentally published to pub.dev.
