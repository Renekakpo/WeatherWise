import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/utils/weather_description.dart';
import '../../../utils/wcolors.dart';
import '../../settings/presentation/view_model/settings_view_model.dart';
import '../domain/entities/weather.dart';
import 'providers/weather_providers.dart';
import 'view_model/current_weather_view_model.dart';
import 'view_model/forecast_view_model.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/forecast_card.dart';
import 'widgets/sun_state_card.dart';
import 'widgets/weather_details_card.dart';

class WeatherView extends ConsumerStatefulWidget {
  const WeatherView({super.key});

  @override
  ConsumerState<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends ConsumerState<WeatherView> {
  int? _lastNotifiedDt;

  @override
  Widget build(BuildContext context) {
    final asyncWeather = ref.watch(currentWeatherViewModelProvider);
    final asyncForecast = ref.watch(forecastViewModelProvider);
    final settings = ref.watch(settingsViewModelProvider).valueOrNull;

    ref.listen<AsyncValue<Weather>>(currentWeatherViewModelProvider,
        (previous, next) {
      next.whenData(_maybeShowNotification);
    });

    return asyncWeather.when(
      loading: _buildLoader,
      error: (e, _) => _buildError(e),
      data: (weather) {
        return asyncForecast.when(
          loading: _buildLoader,
          error: (e, _) => _buildError(e),
          data: (forecast) {
            final grouped = ref
                .read(groupForecastByDayUseCaseProvider)
                .call(forecast);
            return SingleChildScrollView(
              child: Container(
                color: WColors.blueGray500,
                padding: const EdgeInsets.only(bottom: 10.0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    CurrentWeatherCard(weather: weather),
                    const SizedBox(height: 20.0),
                    ForecastCard(
                      key: const Key('ForecastCard'),
                      groupedByDay: grouped,
                    ),
                    const SizedBox(height: 20.0),
                    SunStateCard(
                      sunriseTimestamp: weather.sunriseTimestamp,
                      sunsetTimestamp: weather.sunsetTimestamp,
                    ),
                    const SizedBox(height: 20.0),
                    if (settings != null)
                      WeatherDetailsCard(
                        weather: weather,
                        unit: settings.unit,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _maybeShowNotification(Weather weather) async {
    if (_lastNotifiedDt == weather.observedAt) return;
    _lastNotifiedDt = weather.observedAt;

    final granted = await Permission.notification.isGranted;
    if (!granted) {
      if (kDebugMode) debugPrint('Notification permission denied');
      return;
    }
    final settings = ref.read(settingsViewModelProvider).valueOrNull;
    final symbol = (settings?.unit.temperatureSymbol) ?? 'ºC';
    final body = 'Today feels like ${weather.feelsLike.round()}$symbol.\n'
        '${getWeatherDescription(weather.feelsLike)}';

    await ref.read(notificationServiceProvider).showWeatherNotification(
          title: weather.locationName,
          body: body,
          weatherIconUrl: weather.iconUrl,
          notificationId: 1,
        );
  }

  Widget _buildLoader() => Center(
        key: const Key('lottie loader'),
        child: Lottie.asset(
          'assets/icons/loader_animation.json',
          width: 120.0,
          height: 120.0,
        ),
      );

  Widget _buildError(Object error) => Center(
        key: const Key('Weather details access'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            error is StateError
                ? 'You must enable location services and grant location '
                    'permissions, or set a favorite location to view weather '
                    'details.'
                : 'Could not load weather: $error',
            textAlign: TextAlign.center,
          ),
        ),
      );
}
