import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'base_state.dart';
import '../network/exceptions.dart'; // For handling specific exceptions
// import '../di/service_locator.dart'; // If a logger is injected
// import 'package:logger/logger.dart'; // Example logger
import 'package:bloc_concurrency/bloc_concurrency.dart';


// Placeholder for a logger, replace with actual logger from core/logging later
// For now, using print for simplicity as logger module is not yet defined.
class _BaseBlocLogger {
  void info(String message) => print('[INFO][BaseBloc] $message');
  void warning(String message, [dynamic error, StackTrace? stackTrace]) => print('[WARNING][BaseBloc] $message ${error?.toString()}');
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    print('[ERROR][BaseBloc] $message');
    if (error != null) {
      print('  Error: ${error.toString()}');
    }
    if (stackTrace != null) {
      print('  StackTrace: $stackTrace');
    }
  }
}


abstract class BaseBloc<Event, State extends BaseState> extends Bloc<Event, State> {
  // final Logger logger = getIt<Logger>(); // Example if logger is via DI
  final _BaseBlocLogger logger = _BaseBlocLogger(); // Using placeholder logger

  BaseBloc(State initialState) : super(initialState) {
    on<Event>(_eventTransformer, transformer: bloc_concurrency.droppable());
  }

  // Default event transformer. Can be overridden by subclasses if needed.
  // Uses droppable() to prevent processing new events while one is active.
  // Consider other transformers like sequential(), restartable() based on needs.
  void _eventTransformer(Event event, Emitter<State> emit) async {
    logger.info('Processing event: ${event.runtimeType}');
    try {
      // Emit loading state
      // Note: Casting to dynamic first then to State to satisfy type checker
      // This is a common pattern when you don't know the exact type of State
      // but know it will be a subtype of BaseState.
      // Ensure your specific Blocs handle this appropriately or provide a specific LoadingState factory.
      if (this is! Bloc<Event, LoadingState>) { // Avoid emitting LoadingState if current state is already Loading
         // emit(const LoadingState() as State); // This might need adjustment based on specific State types
      }

      await handleEvent(event, emit);

      // Optionally emit a generic SuccessState if no specific success state was emitted by handleEvent
      // if (!emit.isDone && state is! SuccessState && state is! ErrorState) {
      //   emit(const SuccessState() as State);
      // }
    } catch (e, stackTrace) {
      logger.error('Error processing event ${event.runtimeType}', e, stackTrace);
      await handleError(e, stackTrace, emit);
    }
  }

  /// Abstract method to be implemented by subclasses to handle specific events.
  /// Should emit appropriate states based on the event.
  @protected
  Future<void> handleEvent(Event event, Emitter<State> emit);

  /// Handles errors caught during event processing.
  /// Emits an ErrorState with a user-friendly message.
  /// Can be overridden for more specific error handling.
  @protected
  Future<void> handleError(Object e, StackTrace stackTrace, Emitter<State> emit) async {
    String errorMessage = 'An unexpected error occurred.';
    String? errorDetails;

    if (e is ServerException) {
      errorMessage = e.message;
      errorDetails = 'ServerException: ${e.message} (Code: ${e.statusCode})';
    } else if (e is NetworkException) {
      errorMessage = e.message;
      errorDetails = 'NetworkException: ${e.message}';
    } else if (e is UnauthorizedException) {
      errorMessage = e.message; // Or a more generic "Session expired"
      errorDetails = 'UnauthorizedException: ${e.message}';
      // Optionally, trigger navigation to login or a global auth event
    } else if (e is CacheException) {
      errorMessage = 'Could not load data from cache. ${e.message}';
      errorDetails = 'CacheException: ${e.message}';
    } else {
      // For other unhandled exceptions
      errorDetails = e.toString();
    }

    logger.error('Mapped error to user message: "$errorMessage", Details: "$errorDetails"');
    // Ensure state type compatibility
    // This cast is a common challenge with generic BaseBlocs.
    // Subclasses might need to handle ErrorState emission more specifically if State isn't directly BaseState.
    emit(ErrorState(message: errorMessage, details: errorDetails) as State);
  }
}
