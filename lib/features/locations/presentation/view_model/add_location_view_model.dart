import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../settings/presentation/view_model/settings_view_model.dart';
import '../../../weather/presentation/providers/weather_providers.dart';
import '../../domain/entities/city_suggestion.dart';
import '../../domain/entities/saved_location.dart';
import '../providers/locations_providers.dart';
import 'manage_locations_view_model.dart';

class AddLocationState {
  const AddLocationState({
    this.suggestions = const [],
    this.errorMessage,
  });

  final List<CitySuggestion> suggestions;
  final String? errorMessage;

  AddLocationState copyWith({
    List<CitySuggestion>? suggestions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddLocationState(
      suggestions: suggestions ?? this.suggestions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AddLocationViewModel extends AsyncNotifier<AddLocationState> {
  @override
  Future<AddLocationState> build() async => const AddLocationState();

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData(AddLocationState());
      return;
    }
    final result =
        await ref.read(searchCitiesUseCaseProvider)(query);
    state = result.fold(
      onSuccess: (cities) => AsyncData(AddLocationState(suggestions: cities)),
      onFailure: (f) =>
          AsyncData(AddLocationState(errorMessage: f.message)),
    );
  }

  /// Fetches weather for the picked city via the WeatherRepository,
  /// builds a SavedLocation, persists it, then triggers a refresh of the
  /// manage-locations list + favorite watcher.
  Future<bool> addCity(CitySuggestion city) async {
    state = const AsyncLoading();
    final settings = ref.read(settingsViewModelProvider).value;
    final unit = settings?.unit;
    if (unit == null) {
      state = AsyncError(
        const UnknownFailure(),
        StackTrace.current,
      );
      return false;
    }

    final weatherResult =
        await ref.read(getCurrentWeatherUseCaseProvider)(
      latitude: city.latitude,
      longitude: city.longitude,
      unit: unit,
    );

    final weather = weatherResult.fold(
      onSuccess: (w) => w,
      onFailure: (_) => null,
    );

    if (weather == null) {
      state = AsyncError(
        weatherResult.failureOrNull ?? const UnknownFailure(),
        StackTrace.current,
      );
      return false;
    }

    final location = SavedLocation(
      name: weather.locationName,
      region: city.adminName,
      latitude: weather.latitude,
      longitude: weather.longitude,
      isFavorite: false,
      useDeviceLocation: false,
      weatherCondition: weather.condition,
      weatherIconId: weather.iconId,
      currentTemperature: weather.temperature,
      minTemperature: weather.tempMin,
      maxTemperature: weather.tempMax,
    );

    final saveResult = await ref.read(saveLocationUseCaseProvider)(location);
    return saveResult.fold(
      onSuccess: (_) {
        state = const AsyncData(AddLocationState());
        ref.invalidate(manageLocationsViewModelProvider);
        ref.invalidate(favoriteLocationProvider);
        return true;
      },
      onFailure: (f) {
        state = AsyncError(f, StackTrace.current);
        return false;
      },
    );
  }
}

final addLocationViewModelProvider =
    AsyncNotifierProvider<AddLocationViewModel, AddLocationState>(
  AddLocationViewModel.new,
  isAutoDispose: true,
);
