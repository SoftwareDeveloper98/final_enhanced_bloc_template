# CI/CD (Continuous Integration / Continuous Deployment)

This document outlines the CI/CD strategy and setup for the Flutter Enterprise Scaffold App. The primary tool used for CI/CD is **GitHub Actions**.

## Overview

The CI/CD pipeline is defined in `.github/workflows/ci.yaml`. Its main goals are:
1.  **Automated Checks:** Ensure code quality, style consistency, and correctness on every push and pull request.
2.  **Automated Testing:** Run unit, widget, and integration tests to catch regressions early.
3.  **Automated Builds:** (Optional, can be extended) Build application bundles (APK, AppBundle, IPA) for different environments.
4.  **Automated Deployment:** (Optional, can be extended) Deploy builds to testing tracks (e.g., Firebase App Distribution, TestFlight) or even production.

## Workflow (`.github/workflows/ci.yaml`)

Refer to the [`.github/workflows/ci.yaml`](../../.github/workflows/ci.yaml) file for the actual implementation.
Key stages typically include:

1.  **Trigger:**
    *   On pushes to `main`, `develop` branches.
    *   On pull requests targeting `main` or `develop`.

2.  **Setup Environment:**
    *   Checkout the code.
    *   Set up Flutter SDK (specific version).
    *   Set up Java (for Android builds).
    *   Set up Ruby and Cocoapods (for iOS builds, if not using a pre-built Flutter environment that includes it).
    *   (If using Melos) Bootstrap the project: `melos bootstrap` or `dart run melos bootstrap`.

3.  **Static Analysis & Formatting:**
    *   **Format Check:** `dart format --output=none --set-exit-if-changed .` (run via Melos: `melos run format_check`)
    *   **Linting:** `flutter analyze` (run via Melos: `melos run analyze_all`)

4.  **Testing:**
    *   **Unit & Widget Tests:** `flutter test` (run via Melos: `melos run test_all`)
        *   Coverage reports can be generated using `flutter test --coverage`.
        *   Coverage data can be uploaded to services like Codecov.
    *   **Integration Tests:** `flutter test integration_test`
        *   Requires an emulator (Android) or simulator (iOS) to run.
        *   The `ci.yaml` example includes a job using `reactivecircus/android-emulator-runner` for Android integration tests. iOS simulators on GitHub Actions macOS runners are also possible.

5.  **Build (Optional - typically on specific triggers like merges to `develop` or `main`):**
    *   **Android:**
        *   `flutter build apk --flavor <flavor> -t lib/main_<flavor>.dart --release`
        *   `flutter build appbundle --flavor <flavor> -t lib/main_<flavor>.dart --release`
    *   **iOS:**
        *   `flutter build ipa --flavor <flavor> -t lib/main_<flavor>.dart --release --export-options-plist=path/to/ExportOptions.plist`
    *   Build artifacts can be uploaded using `actions/upload-artifact`.

6.  **Deployment (Optional - e.g., on merges to `main` for production, or `develop` for internal testing):**
    *   **Firebase App Distribution:** Use tools like `firebase-tools` or dedicated GitHub Actions (e.g., `wzieba/Firebase-Distribution-Github-Action`).
    *   **TestFlight / App Store Connect:** Use tools like Fastlane (often run via `fastlane-action`) or other specialized actions.
    *   **Google Play Store:** Use tools like Fastlane, `gradle-play-publisher` (for Android), or dedicated GitHub Actions.

## Secrets Management

-   API keys, signing keys, and other secrets required for builds or deployment should be stored as GitHub Encrypted Secrets in the repository settings.
-   Access these secrets in the workflow using `${{ secrets.YOUR_SECRET_NAME }}`.
-   **Never commit secrets directly to the repository.**

## Melos Integration

-   If using Melos (as per `melos.yaml`), CI scripts should leverage Melos for running commands across multiple packages:
    *   `melos bootstrap` (or `dart run melos bootstrap`) for dependency fetching.
    *   `melos run analyze_all` for linting all packages.
    *   `melos run test_all` for testing all packages.
    *   `melos run format_check` for formatting.

## Future Enhancements

-   **Selective Testing/Building:** Optimize CI runtimes by only testing/building packages affected by a change (Melos can help with this using `melos exec --scope="...changed..."`).
-   **Caching:** Cache Flutter dependencies, pub dependencies, and build artifacts to speed up workflows. GitHub Actions offers caching mechanisms.
-   **Matrix Builds:** Run tests and builds across different Flutter versions, OS versions, or device types if needed.
-   **Automated Release Notes Generation.**
-   **Security Scans:** Integrate tools for vulnerability scanning of dependencies or static application security testing (SAST).

This CI/CD setup provides a robust automated pipeline to ensure code quality and enable efficient delivery of the application. Regular review and updates to the pipeline are recommended as the project and its requirements evolve.
