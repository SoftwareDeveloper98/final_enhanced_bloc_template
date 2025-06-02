# Feature-Based Theme Extensions Strategy

This directory contains the core application theme (`app_theme.dart`). To allow features to define their own specific theme properties without cluttering the global `ThemeData` and to promote modularity, we use Flutter's `ThemeExtension<T>` mechanism.

## Concept

1.  **Define Extension:** Each feature that requires custom theme properties (colors, text styles, specific component themes not covered by global theme) defines its own class that extends `ThemeExtension<YourFeatureThemeExtension>`.
    *   This class holds all the feature-specific theme properties.
    *   It must implement `copyWith` and `lerp` methods.
    *   It's good practice to provide static `light` and `dark` (and potentially other) predefined instances of the extension.
    *   Example: `lib/features/profile/presentation/theme/profile_theme_extension.dart`

2.  **Register Extension:** The main application `ThemeData` (in `app_theme.dart`) is configured to include instances of these feature-specific theme extensions in its `extensions` list.
    ```dart
    // In lib/shared/themes/app_theme.dart
    ThemeData get lightTheme {
      return ThemeData(
        // ... global theme properties ...
        extensions: const <ThemeExtension<dynamic>>[
          ProfileThemeExtension.light, // From the profile feature
          // OtherFeatureThemeExtension.light, // From another feature
        ],
      );
    }
    ```

3.  **Access in Widgets:** Widgets within a feature can then access their specific theme properties using `Theme.of(context).extension<YourFeatureThemeExtension>()`.
    ```dart
    // In a widget within the profile feature
    final profileTheme = Theme.of(context).extension<ProfileThemeExtension>();
    Color? avatarBorderColor = profileTheme?.profileAvatarBorderColor;
    ```

## Benefits

*   **Modularity:** Theme properties are co-located with the feature code.
*   **Decoupling:** Features don't need to modify global theme files directly to add their specific styles; they just define their extension.
*   **Scalability:** Easier to manage themes in large applications with many features.
*   **Clarity:** `ThemeData` remains focused on global styling, while feature-specifics are encapsulated.
*   **Type Safety:** Accessing extensions is type-safe.

## Workflow

1.  Feature developer identifies need for custom theme properties.
2.  Creates a `MyFeatureThemeExtension extends ThemeExtension<MyFeatureThemeExtension>` in their feature's theme directory (e.g., `lib/features/my_feature/presentation/theme/`).
3.  Defines required properties, `light`/`dark` instances, `copyWith`, and `lerp`.
4.  Adds their `MyFeatureThemeExtension.light` and `MyFeatureThemeExtension.dark` to the `extensions` list in `lib/shared/themes/app_theme.dart`.
5.  Uses `Theme.of(context).extension<MyFeatureThemeExtension>()` in feature widgets.

This approach ensures that the main theme can be composed with feature-specific styling in a clean and maintainable way.
