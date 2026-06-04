import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/entities/temperature_unit.dart';
import '../providers/settings_providers.dart';

class SettingsViewModel extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final result = await ref.read(getSettingsUseCaseProvider)();
    return result.fold(
      onSuccess: (s) => s,
      onFailure: (f) => throw f,
    );
  }

  Future<void> setUnit(TemperatureUnit unit) async {
    final current = state.value ?? const AppSettings.defaults();
    final previous = state;
    state = AsyncData(current.copyWith(unit: unit));
    final result =
        await ref.read(updateTemperatureUnitUseCaseProvider)(current, unit);
    result.fold(
      onSuccess: (updated) => state = AsyncData(updated),
      onFailure: (f) {
        state = previous;
        state = AsyncError(f, StackTrace.current);
      },
    );
  }

  Future<void> setAutoRefreshHours(int hours) async {
    final current = state.value ?? const AppSettings.defaults();
    final previous = state;
    state = AsyncData(current.copyWith(autoRefreshHours: hours));
    final result =
        await ref.read(updateAutoRefreshUseCaseProvider)(current, hours);
    result.fold(
      onSuccess: (updated) => state = AsyncData(updated),
      onFailure: (f) {
        state = previous;
        state = AsyncError(f, StackTrace.current);
      },
    );
  }

  Future<void> setRefreshOnTheGo(bool value) async {
    final current = state.value ?? const AppSettings.defaults();
    final previous = state;
    state = AsyncData(current.copyWith(refreshOnTheGo: value));
    final result =
        await ref.read(updateRefreshOnTheGoUseCaseProvider)(current, value);
    result.fold(
      onSuccess: (updated) => state = AsyncData(updated),
      onFailure: (f) {
        state = previous;
        state = AsyncError(f, StackTrace.current);
      },
    );
  }
}

/// Kept alive across the app lifetime: settings are read by many features
/// (weather, locations, home drawer) and should not be re-fetched each time
/// the screen comes into view.
final settingsViewModelProvider =
    AsyncNotifierProvider<SettingsViewModel, AppSettings>(
  SettingsViewModel.new,
);
