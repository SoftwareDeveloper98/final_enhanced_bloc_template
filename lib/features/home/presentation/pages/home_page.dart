import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:clean_bloc_template/core/accessibility/accessibility_utils.dart';
import 'package:clean_bloc_template/core/config/feature_flags.dart';
import 'package:clean_bloc_template/core/infrastructure/theme/theme_cubit.dart';
import 'package:clean_bloc_template/core/monitoring/performance_monitor.dart';
import 'package:clean_bloc_template/features/home/domain/entities/item.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_bloc.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_event.dart';
import 'package:clean_bloc_template/features/home/presentation/bloc/home_state.dart';
import 'package:clean_bloc_template/features/home/presentation/widgets/item_list.dart';

/// Home page that demonstrates the Clean Architecture and BLoC pattern
/// 
/// This page showcases:
/// - BLoC pattern for state management
/// - Clean separation of UI and business logic
/// - Proper error handling
/// - Accessibility features
/// - Performance monitoring
/// - Feature flagging
class HomePage extends StatefulWidget {
  /// Creates a HomePage
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Start performance monitoring for this page
    PerformanceMonitor.instance.startOperation('home_page_load');
    
    // Dispatch event to load items when the page is initialized
    context.read<HomeBloc>().add(LoadItems());
  }

  @override
  void dispose() {
    // End performance monitoring when the page is disposed
    PerformanceMonitor.instance.endOperation('home_page_load');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home').withAccessibleText(),
        actions: [
          // Theme toggle button with accessibility support
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ).withSemanticLabel('Toggle theme mode'),
          
          // Only show settings button if the feature is enabled
          if (context.isFeatureEnabled('debug_tools'))
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Navigate to settings page if available
                if (context.isFeatureEnabled('settings_page')) {
                  context.push('/settings');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings not available')),
                  );
                }
              },
            ).withSemanticLabel('Settings'),
        ],
      ),
      body: PerformanceMonitorWidget(
        widgetName: 'HomePageBody',
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text('Press the button to load items')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (items) => _buildContent(context, items),
              error: (message) => _buildError(context, message),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeBloc>().add(RefreshItems());
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ).withSemanticLabel('Refresh items'),
    );
  }

  Widget _buildContent(BuildContext context, List<Item> items) {
    if (items.isEmpty) {
      return const Center(
        child: Text('No items available'),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Items (${items.length})',
            style: Theme.of(context).textTheme.headlineSmall,
          ).withAccessibleText(),
        ),
        
        // Show experimental UI if the feature is enabled
        if (context.isFeatureEnabled('experimental_ui'))
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text('Experimental UI Enabled')
                .withSemanticLabel('Experimental features are currently enabled'),
          ),
        
        Expanded(
          child: ItemList(items: items),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red,
          ).withSemanticLabel('Error icon'),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.headlineSmall,
          ).withAccessibleText(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ).withAccessibleText(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(RefreshItems());
            },
            child: const Text('Try Again'),
          ).withSemanticLabel('Try loading items again'),
        ],
      ),
    );
  }
}
