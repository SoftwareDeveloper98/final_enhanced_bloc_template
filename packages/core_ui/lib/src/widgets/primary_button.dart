import 'package:flutter/material.dart';

/// A primary button that shows a loading indicator when an async operation is in progress.
class PrimaryButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// A flag to indicate if the button is in a loading state.
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24.0,
              width: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(text),
    );
  }
}
