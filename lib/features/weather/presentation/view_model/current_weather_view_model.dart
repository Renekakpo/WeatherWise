import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/view_model/settings_view_model.dart';
import '../../domain/entities/weather.dart';
import '../providers/weather_providers.dart';
import 'weather_source.dart';

class CurrentWeatherViewModel extends AsyncNotifier<Weather> {
  @override
  Future<Weather> build() async {
    final source = await ref.watch(weatherSourceProvider.future);
    if (source == null) {
      throw StateError('No weather source: enable location or set a favorite.');
    }
    final settings = await ref.watch(settingsViewModelProvider.future);
    final result = await ref.read(getCurrentWeatherUseCaseProvider)(
      latitude: source.latitude,
      longitude: source.longitude,
      unit: settings.unit,
    );
    return result.fold(
      onSuccess: (w) => w,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final currentWeatherViewModelProvider =
    AsyncNotifierProvider<CurrentWeatherViewModel, Weather>(
  CurrentWeatherViewModel.new,
  isAutoDispose: true,
);
