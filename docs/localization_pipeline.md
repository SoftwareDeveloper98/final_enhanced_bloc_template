# Localization Pipeline

This document outlines the strategy for managing translations at scale, ensuring an efficient and collaborative workflow.

## Source of Truth
The primary source for all translatable strings is a centralized platform, typically a Google Sheet or a specialized translation management system (TMS) like Lokalise, Phrase, Crowdin, or Transifex. This approach allows translators, UX writers, and content managers to update translations without needing direct access to the codebase or understanding developer tools.

The typical structure for managing translations (e.g., in a Google Sheet) includes columns such as:
-   `key`: A unique identifier for the string (e.g., `auth_loginButton`, `shared_errorMessage`, `profile_editProfile_title`). Keys should be prefixed with their feature or scope to prevent collisions.
-   `en`: The English (or source language) translation.
-   `es`: Spanish translation.
-   `fr`: French translation.
-   `de`: German translation.
-   ... (columns for other target languages)
-   `description` (Optional): A brief explanation of the string's context for translators.
-   `feature_scope` (Optional): Helps in categorizing and filtering strings (e.g., 'auth', 'home', 'shared', 'profile').
-   `status` (Optional): Tracks the translation status (e.g., 'needs_translation', 'needs_review', 'approved').

## CI/CD Integration & Automation
A script (e.g., Python, Dart, Node.js) is integrated into the Continuous Integration/Continuous Deployment (CI/CD) pipeline to automate the flow of translations from the source of truth into the application. This script typically performs the following steps:

1.  **Fetch Data:**
    *   The script authenticates with the Google Sheets API (or the API of the chosen TMS).
    *   It downloads the latest translations, usually as a CSV file or directly via API calls.

2.  **Validate Data:**
    *   Perform basic validation checks on the fetched data, such as:
        *   Ensuring all keys are unique.
        *   Checking for missing mandatory translations (e.g., if a key has an `en` string but is missing `es`).
        *   Verifying key naming conventions.

3.  **Generate ARB Files:**
    *   The script processes the validated data and generates/updates the `.arb` (Application Resource Bundle) files for each language.
    *   It separates strings into appropriate ARB files based on their scope:
        *   Shared strings go into common ARB files (e.g., `lib/l10n/arb/app_en.arb`, `lib/l10n/arb/app_es.arb`).
        *   Feature-specific strings go into ARB files within their respective feature directories (e.g., `lib/features/auth/l10n/arb/auth_en.arb`, `lib/features/auth/l10n/arb/auth_es.arb`).
    *   The script ensures that only approved or reviewed translations are included in the ARB files if status tracking is used.

4.  **Commit Changes (Optional but Recommended):**
    *   If the ARB files have changed as a result of the script, these changes are automatically committed back to the feature branch or main branch in the version control system (e.g., Git). This keeps the ARB files in sync with the latest translations.

5.  **Code Generation:**
    *   After the ARB files are updated (and committed), the standard Flutter command `flutter gen-l10n` is executed by the CI job.
    *   This command uses the configuration in `l10n.yaml` to regenerate the strongly-typed Dart localization classes (e.g., `AppLocalizations`).
    *   If feature-specific ARBs are not merged into the main `arb-dir` defined in `l10n.yaml`, a strategy to handle them must be in place (e.g., the script merges them first, or multiple `gen-l10n` runs with different configs are used).

## Benefits
-   **Decoupling:** Translators and content managers can work on translations independently of developers and the development sprint cycle.
-   **Automation:** Reduces manual effort, minimizes human error in copying/pasting translations, and ensures ARB files are always up-to-date.
-   **Scalability:** Efficiently handles a large number of strings, multiple languages, and many features.
-   **Version Control:** ARB files are version-controlled, providing a clear history of translation changes and facilitating rollbacks if needed.
-   **Single Source of Truth:** Prevents discrepancies that can arise if translations are managed in multiple places.
-   **Faster Turnaround:** New translations can be integrated into the app more quickly.

## Tooling Considerations
-   **API Clients:** Google Sheets API client libraries, or SDKs for the chosen TMS.
-   **Data Parsing:** Libraries for parsing CSV or JSON data (if the API returns data in these formats).
-   **Scripting Language:** Dart (can be run via `dart run`), Python, Node.js, or shell scripts are common choices.
-   **Authentication:** Secure management of API keys or service account credentials for accessing the translation platform (e.g., using CI/CD environment variables or secrets management).
-   **Error Handling:** The script should have robust error handling and logging to report issues during any step of the pipeline.

This pipeline ensures that localization is a smooth, automated, and scalable part of the development lifecycle.
