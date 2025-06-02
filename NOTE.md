To enable `freezed` and `json_serializable` for code generation, the following dependencies need to be added to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  # ... other dependencies ...
  freezed_annotation: ^2.4.1 # Or latest
  json_annotation: ^4.8.1 # Or latest

dev_dependencies:
  flutter_test:
    sdk: flutter
  # ... other dev_dependencies ...
  build_runner: ^2.4.8 # Or latest
  freezed: ^2.4.7 # Or latest
  json_serializable: ^6.7.1 # Or latest
```

After adding these dependencies, run the following command in the terminal to fetch them:
`flutter pub get`

And to run the code generator:
`flutter pub run build_runner build --delete-conflicting-outputs`
