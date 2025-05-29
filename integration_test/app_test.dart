import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:clean_bloc_template/main.dart' as app;
import 'package:clean_bloc_template/features/home/presentation/pages/home_page.dart';
import 'package:clean_bloc_template/features/home/presentation/widgets/item_list.dart';

/// This integration test demonstrates a complete user flow through the app.
/// 
/// Integration tests verify that different parts of the app work together correctly
/// and that the app behaves as expected during real-world usage scenarios.
void main() {
  // Initialize the IntegrationTestWidgetsFlutterBinding
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Verify complete user flow through the app', (tester) async {
      // Initialize the app
      app.main();
      
      // Wait for the app to fully load and stabilize
      await tester.pumpAndSettle();

      // Verify that we're on the HomePage
      expect(find.byType(HomePage), findsOneWidget);

      // Wait for data to load (this may take some time in a real app)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify that the ItemList is displayed
      expect(find.byType(ItemList), findsOneWidget);

      // Test theme toggle functionality
      final themeButton = find.byIcon(Icons.brightness_6);
      expect(themeButton, findsOneWidget);
      await tester.tap(themeButton);
      await tester.pumpAndSettle();
      
      // Verify theme change (this would depend on your specific UI indicators)
      // In a real test, you might check for specific colors or theme-dependent widgets

      // Test refresh functionality
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);
      await tester.tap(refreshButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify that the ItemList is still displayed after refresh
      expect(find.byType(ItemList), findsOneWidget);
      
      // Test error handling (if possible in your app flow)
      // This would typically involve forcing an error condition
      // and verifying that error UI is displayed correctly
      
      // Example of testing navigation (if applicable)
      // final itemToTap = find.text('Test Item 1');
      // await tester.tap(itemToTap);
      // await tester.pumpAndSettle();
      // expect(find.byType(ItemDetailPage), findsOneWidget);
    });
    
    // Additional test for accessibility
    testWidgets('Verify accessibility features', (tester) async {
      // Initialize the app
      app.main();
      await tester.pumpAndSettle();

      // Check that Semantics are properly applied
      final semantics = tester.getSemantics(find.byType(HomePage));
      expect(semantics.label, isNotEmpty); // Verify semantic label exists
      
      // Check that important UI elements have semantic labels
      expect(tester.getSemantics(find.byIcon(Icons.refresh)).label, isNotEmpty);
      expect(tester.getSemantics(find.byIcon(Icons.brightness_6)).label, isNotEmpty);
    });
  });
}
