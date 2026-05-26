import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/view_model/settings_view_model.dart';
import '../../domain/entities/forecast.dart';
import '../providers/weather_providers.dart';
import 'weather_source.dart';

class ForecastViewModel extends AutoDisposeAsyncNotifier<Forecast> {
  @override
  Future<Forecast> build() async {
    final source = await ref.watch(weatherSourceProvider.future);
    if (source == null) {
      throw StateError('No weather source.');
    }
    final settings = await ref.watch(settingsViewModelProvider.future);
    final result = await ref.read(getForecastUseCaseProvider)(
      latitude: source.latitude,
      longitude: source.longitude,
      unit: settings.unit,
    );
    return result.fold(
      onSuccess: (f) => f,
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final forecastViewModelProvider =
    AsyncNotifierProvider.autoDispose<ForecastViewModel, Forecast>(
  ForecastViewModel.new,
);
