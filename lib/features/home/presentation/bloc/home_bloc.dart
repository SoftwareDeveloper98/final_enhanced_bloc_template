import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart'; // Import for concurrency control
import 'package:injectable/injectable.dart';

import '../../../common/error/failures.dart'; // Updated path
import '../../domain/usecases/get_items.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable // Register HomeBloc with GetIt
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetItems getItemsUseCase;

  HomeBloc(this.getItemsUseCase) : super(HomeInitial()) {
    on<LoadItems>(
      _onLoadItems,
      // Use bloc_concurrency to manage how events are processed.
      // - droppable(): Ignores new events while one is processing.
      // - restartable(): Cancels the previous event handler and starts a new one.
      // - sequential(): Processes events one after another.
      // - concurrent(): Processes events concurrently.
      transformer: droppable(), // Example: Prevent multiple loads at once
    );

    // Example: Listening to another Bloc/Cubit (requires setup)
    // _listenToSettingsChanges(); 
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    // Execute the use case
    final failureOrItems = await getItemsUseCase(NoParams()); // Assuming GetItems uses NoParams

    // Emit the result
    failureOrItems.fold(
      (failure) => emit(HomeError(_mapFailureToMessage(failure))),
      (items) => emit(HomeLoaded(items)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Simple mapping, can be expanded based on Failure types
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error: ${failure.message}';
      case CacheFailure:
        return 'Cache Error: ${failure.message}';
      default:
        return 'An unexpected error occurred: ${failure.message}';
    }
  }

  // --- Example: Bloc-to-Bloc Communication --- 
  // This requires having another Bloc/Cubit (e.g., SettingsCubit) and injecting it
  // or accessing its stream.
  /*
  final SettingsCubit _settingsCubit; // Assuming injected
  StreamSubscription? _settingsSubscription;

  void _listenToSettingsChanges() {
    // Make sure to cancel the subscription in close()
    _settingsSubscription = _settingsCubit.stream.listen((settingsState) {
      // React to settings changes, e.g., reload items if a relevant setting changed
      if (settingsState.someSettingChanged) {
         add(LoadItems()); // Example: Reload items on setting change
      }
    });
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
  */
}

