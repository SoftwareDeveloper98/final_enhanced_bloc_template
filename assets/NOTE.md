# Asset Management Notes

This directory (`assets/`) and its subdirectories are used to store static assets for the application.

## Pubspec Configuration
To make these assets available in your Flutter application, you need to declare them in your `pubspec.yaml` file. Add the following under the `flutter:` section:

```yaml
flutter:
  uses-material-design: true # Ensure this is true if you use Material Design icons/widgets

  assets:
    # List root asset directories. Flutter includes all files within these directories.
    - assets/images/ # Includes all images in subdirectories like branding/ and features/
    - assets/icons/
    # If you had other root asset types, like fonts or data files:
    # - assets/fonts/
    # - assets/data/

    # To be more explicit and list individual files (less common for images/icons unless specific ones):
    # - assets/images/branding/logo.png
    # - assets/icons/home_icon.svg
```
Make sure to run `flutter pub get` after modifying `pubspec.yaml`.

## Icons
-   **SVGs Preferred:** For icons, prefer using Scalable Vector Graphics (SVGs) and place them in `assets/icons/`. Use the `flutter_svg` package from pub.dev to render SVGs in your application. This ensures your icons are sharp at any scale.
-   **Icon Fonts:** For very complex icons or when SVGs are not suitable (e.g., legacy systems, specific design requirements), consider using custom icon fonts. Place font files in `assets/fonts/` and declare them in `pubspec.yaml`.

## Images
-   **Directory Structure:** Place raster images (PNG, JPG, GIF, WebP) in `assets/images/`.
    -   `assets/images/branding/` for app-wide branding elements (logos, etc.).
    -   `assets/images/features/<feature_name>/` for images specific to a particular feature (e.g., `assets/images/features/onboarding/welcome_graphic.png`).
    -   General images can go directly into `assets/images/` or a relevant subdirectory.
-   **Optimization:** Always optimize images for size and performance before adding them to the project. Use tools like ImageOptim, TinyPNG, Squoosh, or similar.
-   **Resolution Variants:** For pixel-perfect rendering on high-DPI (Dots Per Inch) screens, provide 2.0x and 3.0x resolution variants for your raster images. Flutter automatically selects the appropriate variant based on the device's pixel ratio.
    Example structure:
    ```
    assets/images/my_image.png       (1.0x baseline)
    assets/images/2.0x/my_image.png  (2.0x variant)
    assets/images/3.0x/my_image.png  (3.0x variant)
    ```
    If you only provide a single high-resolution image (e.g., `my_image.png` at 3.0x scale), Flutter will scale it down for lower resolution screens, which is generally acceptable but might not be as crisp as providing specific variants.

## Asset Generation (Recommended)
-   **Strongly-Typed Access:** To avoid typos and improve maintainability when referencing asset paths in code, consider using an asset generator tool like `flutter_gen_runner` (or `flutter_gen`). This tool generates Dart constants for your asset paths.
-   **Setup:**
    1.  Add `flutter_gen_runner` to your `dev_dependencies` in `pubspec.yaml`.
    2.  Add `flutter_gen` (the runtime part) to `dependencies` in `pubspec.yaml`.
    3.  Create a `build.yaml` file in your project root to configure `flutter_gen_runner`.
        Example `build.yaml`:
        ```yaml
        # build.yaml
        targets:
          $default:
            builders:
              flutter_gen_runner:
                options:
                  # See package readme for all options: https://pub.dev/packages/flutter_gen_runner
                  # enabled: true # Usually enabled by default
                  output: lib/generated/assets.gen.dart # Output file path
                  line_length: 80 # Optional line length for generated file

                  # Configure which asset types to generate constants for
                  assets:
                    enabled: true
                    # Optional: specify a class name for assets
                    # class_name: Assets
                    # Optional: specify package parameter for assets if assets are located in a package.
                    # package_parameter_enabled: false
                    # Optional: List of rules for excluding files or directories from generation.
                    # excludes:
                    #   - "**/ignored_folder/**"

                  fonts:
                    enabled: true # If you have custom fonts in assets/fonts/
                    # class_name: AppFonts

                  # colors: # If you want to generate colors from XML or other definition files
                  #   enabled: true
                  #   inputs:
                  #     - assets/colors/colors.xml # Example
        ```
    4.  Run the build runner: `flutter pub run build_runner build --delete-conflicting-outputs`.
-   **Usage:** After generation, you can access assets like `Assets.images.myImage.path` or `Assets.icons.myIcon.svg()`.

By following these guidelines, you can manage your application's assets in a structured, maintainable, and performant way.
