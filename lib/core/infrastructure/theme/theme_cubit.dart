import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart'; // Import HydratedBloc
import 'package:injectable/injectable.dart';

@lazySingleton // Register with GetIt
class ThemeCubit extends HydratedCubit<ThemeMode> {
  // Initialize with system theme as default
  ThemeCubit() : super(ThemeMode.system);

  void setTheme(ThemeMode themeMode) {
    emit(themeMode);
  }

  // --- HydratedBloc Implementation ---

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    try {
      final themeIndex = json['themeModeIndex'] as int?;
      if (themeIndex != null && themeIndex >= 0 && themeIndex < ThemeMode.values.length) {
        return ThemeMode.values[themeIndex];
      }
    } catch (e) {
      // Handle potential errors during deserialization
      print('Error deserializing ThemeMode: $e');
    }
    return ThemeMode.system; // Default to system if error or invalid data
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // Store the index of the enum value
    return {'themeModeIndex': state.index};
  }
}

