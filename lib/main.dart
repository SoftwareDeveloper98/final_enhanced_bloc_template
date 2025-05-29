// This is the default entry point for the application.
// It typically runs the development environment configuration.

import 'main_dev.dart' as dev_main;

void main() {
  // Call the development environment's main function.
  // For production builds, the build process should specify main_prod.dart as the entry point.
  dev_main.main();
}

