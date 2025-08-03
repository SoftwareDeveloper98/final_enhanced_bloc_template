import 'package:flutter/material.dart';

/// A custom text field with consistent styling.
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;

  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        // Use theme colors for better adaptability
        fillColor: Theme.of(context).colorScheme.surface.withAlpha(50),
      ),
    );
  }
}
