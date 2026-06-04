import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/http_client.dart';
import '../../../../core/providers/env_provider.dart';
import '../../data/datasources/weather_remote_data_source.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_current_weather_usecase.dart';
import '../../domain/usecases/get_forecast_usecase.dart';
import '../../domain/usecases/group_forecast_by_day_usecase.dart';

final weatherRemoteDataSourceProvider =
    Provider<WeatherRemoteDataSource>((ref) {
  return WeatherRemoteDataSource(
    httpClient: ref.watch(httpClientProvider),
    apiKey: ref.watch(envProvider).openWeatherApiKey,
  );
});

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(ref.watch(weatherRemoteDataSourceProvider));
});

final getCurrentWeatherUseCaseProvider =
    Provider<GetCurrentWeatherUseCase>((ref) {
  return GetCurrentWeatherUseCase(ref.watch(weatherRepositoryProvider));
});

final getForecastUseCaseProvider = Provider<GetForecastUseCase>((ref) {
  return GetForecastUseCase(ref.watch(weatherRepositoryProvider));
});

final groupForecastByDayUseCaseProvider =
    Provider<GroupForecastByDayUseCase>((_) {
  return const GroupForecastByDayUseCase();
});
