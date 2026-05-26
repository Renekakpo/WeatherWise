import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/providers/env_provider.dart';
import '../../../../network/weather_api_helper.dart';
import '../../../settings/presentation/view_model/settings_view_model.dart';
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

class AddLocationViewModel
    extends AutoDisposeAsyncNotifier<AddLocationState> {
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

  /// Fetches weather for the picked city, builds a SavedLocation, persists it,
  /// then triggers a refresh of the manage-locations list.
  ///
  /// Step 7 still goes through the legacy WeatherApiHelper to avoid pulling
  /// the weather feature migration forward; the call site moves to the
  /// WeatherRepository in step 8.
  Future<bool> addCity(CitySuggestion city) async {
    state = const AsyncLoading();
    try {
      final settings = ref.read(settingsViewModelProvider).valueOrNull;
      final units = (settings?.unit.apiQueryValue) ?? 'metric';
      final apiKey = ref.read(envProvider).openWeatherApiKey;
      final weather = await WeatherApiHelper(apiKey)
          .getCurrentWeatherData(city.latitude, city.longitude, units);

      if (weather == null) {
        state = AsyncError(
          const ApiFailure(0, message: 'Failed to fetch weather'),
          StackTrace.current,
        );
        return false;
      }

      final location = SavedLocation(
        name: weather.name,
        region: city.adminName,
        latitude: weather.coord.lat,
        longitude: weather.coord.lon,
        isFavorite: false,
        useDeviceLocation: false,
        weatherCondition: weather.weather.first.main,
        weatherIconId: weather.weather.first.icon,
        currentTemperature: weather.main.temp,
        minTemperature: weather.main.tempMin,
        maxTemperature: weather.main.tempMax,
      );

      final saveResult =
          await ref.read(saveLocationUseCaseProvider)(location);
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
    } catch (e, st) {
      state = AsyncError(UnknownFailure(cause: e), st);
      return false;
    }
  }
}

final addLocationViewModelProvider =
    AsyncNotifierProvider.autoDispose<AddLocationViewModel, AddLocationState>(
  AddLocationViewModel.new,
);
