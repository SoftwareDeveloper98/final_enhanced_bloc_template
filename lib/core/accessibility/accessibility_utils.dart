import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// A collection of accessibility utilities and extensions to improve app accessibility
class AccessibilityUtils {
  /// Private constructor to prevent instantiation
  AccessibilityUtils._();
  
  /// Check if the device has screen reader enabled
  static Future<bool> isScreenReaderEnabled() async {
    return await SemanticsBinding.instance.accessibilityFeatures.accessibleNavigation;
  }
  
  /// Get recommended minimum touch target size based on platform guidelines
  static Size getMinimumTouchTargetSize() {
    // 48x48 logical pixels is the recommended minimum size for touch targets
    return const Size(48.0, 48.0);
  }
  
  /// Get recommended text scale factor for better readability
  static double getRecommendedTextScaleFactor(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Return the system text scale factor, but ensure it's at least 1.0
    return mediaQuery.textScaleFactor >= 1.0 
        ? mediaQuery.textScaleFactor 
        : 1.0;
  }
}

/// Extension on Widget to add accessibility features
extension AccessibilityWidgetExtension on Widget {
  /// Add semantic label to a widget
  Widget withSemanticLabel(String label) {
    return Semantics(
      label: label,
      child: this,
    );
  }
  
  /// Add semantic hint to a widget
  Widget withSemanticHint(String hint) {
    return Semantics(
      hint: hint,
      child: this,
    );
  }
  
  /// Make a widget a button for screen readers
  Widget asSemanticButton({required String label, VoidCallback? onTap}) {
    return Semantics(
      label: label,
      button: true,
      onTap: onTap,
      child: this,
    );
  }
  
  /// Ensure widget meets minimum touch target size
  Widget withMinimumTouchSize() {
    final minSize = AccessibilityUtils.getMinimumTouchTargetSize();
    return SizedBox(
      width: minSize.width,
      height: minSize.height,
      child: Center(child: this),
    );
  }
}

/// Extension on Text widget for accessibility improvements
extension AccessibilityTextExtension on Text {
  /// Create a text widget with proper semantic label for screen readers
  Text withAccessibleText() {
    return Text(
      data ?? '',
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel ?? data,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}

/// Widget that provides accessibility guidelines and examples
class AccessibilityGuidelinesWidget extends StatelessWidget {
  /// Constructor
  const AccessibilityGuidelinesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Guidelines').withAccessibleText(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Accessibility Best Practices',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ).withAccessibleText(),
              const SizedBox(height: 16),
              
              // Example of accessible button
              ElevatedButton(
                onPressed: () {},
                child: const Text('Accessible Button'),
              ).withSemanticLabel('Example of accessible button with proper label'),
              
              const SizedBox(height: 16),
              
              // Example of minimum touch target size
              IconButton(
                icon: const Icon(Icons.accessibility),
                onPressed: () {},
              ).withMinimumTouchSize().withSemanticLabel('Accessibility icon with minimum touch size'),
              
              const SizedBox(height: 16),
              
              // Example of text with proper contrast
              Container(
                color: Colors.black,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Text with proper contrast',
                  style: TextStyle(color: Colors.white),
                ).withAccessibleText(),
              ),
              
              const SizedBox(height: 16),
              
              // Example of form field with label
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Example of image with description
              Semantics(
                label: 'Example image showing accessibility features',
                image: true,
                child: Container(
                  height: 100,
                  color: Colors.grey,
                  child: const Center(child: Text('Image Placeholder')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
