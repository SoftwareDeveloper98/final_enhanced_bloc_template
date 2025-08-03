import 'package:flutter/material.dart';

/// A simple, centered loading indicator for use on pages or large widgets.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
