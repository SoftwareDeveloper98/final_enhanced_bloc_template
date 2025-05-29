import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_bloc_template/core/common/logging/logging_module.dart'; // For mock logger
import 'package:clean_bloc_template/core/infrastructure/theme/theme_cubit.dart';
import 'package:clean_bloc_template/features/home/domain/entities/item.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_event.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_state.dart';
import 'package:clean_bloc_template/features/home/presentation/pages/home_page.dart';
import 'package:clean_bloc_template/features/home/presentation/widgets/item_list.dart';
import 'package:logger/logger.dart'; // Import Logger

// Mock classes
class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockThemeCubit extends MockCubit<ThemeMode> implements ThemeCubit {}
class MockLogger extends Mock implements Logger {}

// Helper function to wrap widgets for testing
Widget createWidgetUnderTest(Widget child, HomeBloc homeBloc, ThemeCubit themeCubit) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<HomeBloc>.value(value: homeBloc),
      BlocProvider<ThemeCubit>.value(value: themeCubit),
      // Provide mock logger if needed by widgets
      // Provider<Logger>.value(value: MockLogger()), 
    ],
    child: MaterialApp(
      home: child,
      // Add localization delegates if needed for text rendering
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

void main() {
  late MockHomeBloc mockHomeBloc;
  late MockThemeCubit mockThemeCubit;

  setUp(() {
    mockHomeBloc = MockHomeBloc();
    mockThemeCubit = MockThemeCubit();

    // Stub the ThemeCubit state
    when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);
  });

  group('HomePage Widget Tests', () {
    testWidgets('HomePage displays loading indicator when state is HomeLoading', (tester) async {
      // Arrange: Set initial state to HomeLoading
      when(() => mockHomeBloc.state).thenReturn(HomeLoading());

      // Act: Pump the widget
      await tester.pumpWidget(createWidgetUnderTest(const HomePage(), mockHomeBloc, mockThemeCubit));

      // Assert: Verify CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ItemList), findsNothing);
      expect(find.text('Error'), findsNothing);
    });

    testWidgets('HomePage displays ItemList when state is HomeLoaded', (tester) async {
      // Arrange: Set state to HomeLoaded with sample data
      final items = [const Item(id: '1', name: 'Test Item')];
      when(() => mockHomeBloc.state).thenReturn(HomeLoaded(items));

      // Act: Pump the widget
      await tester.pumpWidget(createWidgetUnderTest(const HomePage(), mockHomeBloc, mockThemeCubit));

      // Assert: Verify ItemList is displayed and contains the item
      expect(find.byType(ItemList), findsOneWidget);
      expect(find.text('Test Item'), findsOneWidget); // Check if item text is present
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Error'), findsNothing);
    });

    testWidgets('HomePage displays error message when state is HomeError', (tester) async {
      // Arrange: Set state to HomeError
      when(() => mockHomeBloc.state).thenReturn(const HomeError('Failed to load'));

      // Act: Pump the widget
      await tester.pumpWidget(createWidgetUnderTest(const HomePage(), mockHomeBloc, mockThemeCubit));

      // Assert: Verify error message is displayed
      expect(find.textContaining('Failed to load'), findsOneWidget);
      expect(find.byType(ItemList), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('HomePage dispatches LoadItems event on initialization', (tester) async {
      // Arrange: Set initial state
      when(() => mockHomeBloc.state).thenReturn(HomeInitial());

      // Act: Pump the widget
      await tester.pumpWidget(createWidgetUnderTest(const HomePage(), mockHomeBloc, mockThemeCubit));

      // Assert: Verify LoadItems event was added
      // Note: HomePage adds LoadItems in initState, so it should be called once.
      verify(() => mockHomeBloc.add(LoadItems())).called(1);
    });
    
    testWidgets('HomePage refresh button dispatches RefreshItems event', (tester) async {
      // Arrange: Set initial state to HomeLoaded
      final items = [const Item(id: '1', name: 'Test Item')];
      when(() => mockHomeBloc.state).thenReturn(HomeLoaded(items));

      // Act: Pump the widget
      await tester.pumpWidget(createWidgetUnderTest(const HomePage(), mockHomeBloc, mockThemeCubit));
      
      // Find and tap the refresh button
      final refreshButton = find.byIcon(Icons.refresh);
      expect(refreshButton, findsOneWidget);
      await tester.tap(refreshButton);
      await tester.pump();

      // Assert: Verify RefreshItems event was added
      verify(() => mockHomeBloc.add(RefreshItems())).called(1);
    });
    
    testWidgets('HomePage theme toggle button changes theme mode', (tester) async {
      // Arrange: Set initial state
      when(() => mockHomeBloc.state).thenReturn(HomeInitial());
      when(() => mockThemeCubit.state).thenReturn(ThemeMode.light);

      // Act: Pump the widget
      await tester.pumpWidget(createWidgetUnderTest(const HomePage(), mockHomeBloc, mockThemeCubit));
      
      // Find and tap the theme toggle button
      final themeButton = find.byIcon(Icons.brightness_6);
      expect(themeButton, findsOneWidget);
      await tester.tap(themeButton);
      await tester.pump();

      // Assert: Verify theme toggle was called
      verify(() => mockThemeCubit.toggleTheme()).called(1);
    });
    
    testWidgets('HomePage handles empty item list gracefully', (tester) async {
      // Arrange: Set state to HomeLoaded with empty list
      when(() => mockHomeBloc.state).thenReturn(HomeLoaded([]));

      // Act: Pump the widget
      await tester.pumpWidget(createWidgetUnderTest(const HomePage(), mockHomeBloc, mockThemeCubit));

      // Assert: Verify empty state message is displayed
      expect(find.textContaining('No items available'), findsOneWidget);
      expect(find.byType(ItemList), findsOneWidget); // ItemList should still be present
    });
  });
}
