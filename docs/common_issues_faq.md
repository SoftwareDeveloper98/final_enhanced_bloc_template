# Common Issues & FAQ

This document lists frequently asked questions and common issues encountered by developers working on the Flutter Enterprise Scaffold App, along with their solutions or troubleshooting tips.

## General Setup & Environment

**Q1: Melos bootstrap fails or I get dependency errors.**
*   **A1.1:** Ensure Melos is installed correctly (`dart pub global activate melos` or use `dart run melos bootstrap`).
*   **A1.2:** Make sure your Flutter SDK version matches the one expected by the project (check `environment:` in `pubspec.yaml` files).
*   **A1.3:** Delete `pubspec_overrides.yaml` files in packages and the root `pubspec.lock`, then re-run `melos bootstrap`. This can resolve issues with inconsistent dependency versions.
    ```bash
    find . -name "pubspec_overrides.yaml" -delete
    rm pubspec.lock
    # Potentially remove pubspec.lock from packages too:
    # find packages -name "pubspec.lock" -delete
    melos bootstrap
    ```
*   **A1.4:** Check for any specific error messages. Sometimes a particular package might have a conflict that needs manual resolution in its `pubspec.yaml`.
*   **A1.5:** Ensure you have a stable internet connection.

**Q2: `flutter run --flavor <flavor>` command doesn't work or picks the wrong `main_*.dart` file.**
*   **A2.1:** Double-check that your `launch.json` (for VS Code) or Run/Debug Configurations (for Android Studio/IntelliJ) are correctly set up for each flavor, specifying the correct target (`-t lib/main_<flavor>.dart`) and flavor name.
*   **A2.2:** Ensure the entry point files (`lib/main_dev.dart`, `lib/main_staging.dart`, `lib/main_prod.dart`) exist and are correctly invoking `mainCommon()` or your shared main logic.
*   **A2.3:** Verify native platform configurations for flavors (Xcode schemes for iOS, `build.gradle` flavor dimensions for Android) are correctly set up if you've gone that deep. For simple Dart-defined flavors, this is less of an issue.

**Q3: Environment variables (from `.env` files) are not loading.**
*   **A3.1:** Ensure you are using a package like `flutter_dotenv` to load `.env` files.
*   **A3.2:** Verify that you have correctly named `.env` files (e.g., `.env.dev`, `.env.staging`) and that they are being loaded in the corresponding `main_<flavor>.dart` entry point *before* any services that might need them are initialized. Example: `await dotenv.load(fileName: ".env.dev");`
*   **A3.3:** Make sure the `.env` files are in the root directory of the project.
*   **A3.4:** Remember that changes to `.env` files often require a full app restart (not just hot reload) to take effect.

## Build & Code Generation

**Q4: Build runner (`flutter pub run build_runner build --delete-conflicting-outputs`) fails or takes too long.**
*   **A4.1:** Check the error messages for specific issues (e.g., invalid annotations, conflicts between generated files).
*   **A4.2:** For long build times, ensure your models and classes requiring code generation are well-defined. Sometimes, overly complex or deeply nested structures can slow down generation.
*   **A4.3:** Run `flutter pub clean` (or `melos run clean_all`) and then `melos bootstrap` before retrying the build runner command.
*   **A4.4:** Ensure you have sufficient RAM available; code generation can be memory-intensive.
*   **A4.5:** If using Melos, you can try running build_runner for a specific package: `melos exec --scope=<package_name> -- "flutter pub run build_runner build --delete-conflicting-outputs"`

**Q5: Generated files (`*.g.dart`, `*.freezed.dart`) are showing errors or are out of sync.**
*   **A5.1:** Always re-run the build runner command after making changes to files that are inputs for code generation (e.g., files with `@freezed` annotations, `@injectable` modules, etc.).
*   **A5.2:** Ensure there are no syntax errors in your source files that might be preventing the generator from running correctly.
*   **A5.3:** Check that the versions of your code generation packages (`freezed`, `json_serializable`, `injectable_generator`, etc.) and their annotation counterparts are compatible.

## State Management (BLoC/Cubit Example)

**Q6: My BLoC/Cubit is not emitting new states, or the UI is not updating.**
*   **A6.1:** Ensure your UI widget is correctly providing and listening to the BLoC/Cubit (e.g., using `BlocProvider` and `BlocBuilder`/`BlocListener`).
*   **A6.2:** Verify that new states being emitted are distinct objects. If you are mutating an existing state object and emitting it, BLoC might not recognize it as a new state due to object identity. Ensure you create new instances of state classes (especially if using `Equatable`).
*   **A6.3:** Check your BLoC/Cubit's event handlers. Ensure they are correctly processing events and calling `emit()` with new states.
*   **A6.4:** Use the BLoC observer (`Bloc.observer = MyBlocObserver();`) to log all BLoC transitions and errors, which can help debug state changes.

**Q7: `context.read<MyBloc>()` or `BlocProvider.of<MyBloc>(context)` is failing.**
*   **A7.1:** Make sure `MyBloc` is provided in the widget tree above the widget where you are trying to access it. `BlocProvider` should be placed as high up as necessary but as low down as possible.
*   **A7.2:** If accessing after an `await`, ensure the `BuildContext` is still valid and mounted (`if (context.mounted) { ... }`).

## Testing

**Q8: My tests are failing with "MissingPluginException".**
*   **A8.1:** This often happens in unit tests when trying to use platform channels (e.g., `shared_preferences`, `flutter_secure_storage`). For unit tests, these services should be mocked.
*   **A8.2:** For widget tests, you might need to set up mock method channel handlers using `TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, handler)`. Many plugins offer mock implementations or in-memory versions for testing.

**Q9: How do I test asynchronous code in BLoCs or UseCases?**
*   **A9.1:** Use testing libraries like `bloc_test` for BLoCs/Cubits, which provide utilities like `whenListen` and `expectLater` to handle asynchronous state emissions.
*   **A9.2:** For general async testing, use `async/await` with `expectAsync*` functions or ensure your test function returns a `Future`. Mock dependencies to return `Future.value()` or `Future.error()` as needed.

## Miscellaneous

**Q10: I'm seeing "A RenderFlex overflowed..." errors.**
*   **A10.1:** This is a common Flutter UI layout issue. It means some content is too large for the available space.
    *   Use layout widgets like `Expanded`, `Flexible`, `SingleChildScrollView`, `ListView`, or `FittedBox` to manage content within constraints.
    *   Check for hardcoded sizes that might be too large for smaller screens.
    *   Use the Flutter Inspector to debug layout issues visually.

**Q11: How do I handle different API URLs for dev, staging, and prod?**
*   **A11.1:** This is managed through environment configuration.
    *   If using `String.fromEnvironment`, ensure your build commands for different flavors correctly pass these values or that they are loaded from flavor-specific `main_*.dart` files.
    *   If using `.env` files with `flutter_dotenv`, ensure each `lib/main_<flavor>.dart` loads the correct `.env.<flavor>` file (e.g., `await dotenv.load(fileName: ".env.dev");`). The `NetworkService` or DI setup should then use this loaded configuration.

---
*This FAQ is a living document. Please add new common issues and solutions as they are discovered.*
