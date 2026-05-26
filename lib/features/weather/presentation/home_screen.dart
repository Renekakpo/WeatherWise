import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/constants/strings.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/geolocator_service.dart';
import '../../../utils/wcolors.dart';
import '../../locations/presentation/view_model/manage_locations_view_model.dart';
import '../../settings/presentation/view_model/settings_view_model.dart';
import 'view_model/current_weather_view_model.dart';
import 'view_model/forecast_view_model.dart';
import 'view_model/weather_source.dart';
import 'weather_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StreamSubscription<dynamic>? _locationServiceSub;
  Timer? _autoRefreshTimer;
  int? _scheduledIntervalHours;

  @override
  void initState() {
    super.initState();
    _locationServiceSub = ref
        .read(geolocatorServiceProvider)
        .serviceStatusStream
        .listen((_) {
      ref.invalidate(weatherSourceProvider);
      ref.invalidate(currentWeatherViewModelProvider);
      ref.invalidate(forecastViewModelProvider);
    });
  }

  @override
  void dispose() {
    _locationServiceSub?.cancel();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _maybeScheduleAutoRefresh(int hours) {
    if (hours == _scheduledIntervalHours) return;
    _scheduledIntervalHours = hours;
    _autoRefreshTimer?.cancel();
    if (hours <= 0) return;
    _autoRefreshTimer = Timer.periodic(Duration(hours: hours), (_) {
      ref.invalidate(currentWeatherViewModelProvider);
      ref.invalidate(forecastViewModelProvider);
    });
  }

  Future<void> _pullToRefresh() async {
    final online =
        await ref.read(connectivityServiceProvider).isInternetAvailable();
    if (!online) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection')),
        );
      }
      return;
    }
    ref.invalidate(currentWeatherViewModelProvider);
    ref.invalidate(forecastViewModelProvider);
    try {
      await ref.read(currentWeatherViewModelProvider.future);
      await ref.read(forecastViewModelProvider.future);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Weather data refreshed successfully')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsViewModelProvider).valueOrNull;
    final source = ref.watch(weatherSourceProvider).valueOrNull;
    final favorite = ref.watch(favoriteLocationProvider).valueOrNull;
    final weather = ref.watch(currentWeatherViewModelProvider).valueOrNull;

    if (settings != null) {
      _maybeScheduleAutoRefresh(settings.autoRefreshHours);
    }

    final locationName = weather?.locationName ?? favorite?.name ?? '-';
    final locationEnabled = source?.fromDeviceLocation ?? false;

    Widget body = const WeatherView();
    if (settings?.refreshOnTheGo ?? false) {
      body = RefreshIndicator(onRefresh: _pullToRefresh, child: body);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: WColors.blueGray500,
        iconTheme: const IconThemeData(color: Colors.white),
        title: _AppBarTitle(
          locationEnabled: locationEnabled,
          locationName: locationName,
        ),
      ),
      body: body,
      drawer: SafeArea(
        child: _Drawer(
          favoriteName:
              favorite == null ? null : '${favorite.name}, ${favorite.region}',
          favoriteTemperature: favorite?.currentTemperature,
          tempSymbol: settings?.unit.temperatureSymbol ?? 'ºC',
          locationEnabled: locationEnabled,
          onSettings: () async {
            Navigator.pop(context);
            await context.pushNamed(AppRoute.settings.name);
            ref.invalidate(settingsViewModelProvider);
            ref.invalidate(favoriteLocationProvider);
            ref.invalidate(currentWeatherViewModelProvider);
            ref.invalidate(forecastViewModelProvider);
          },
          onManageLocations: () async {
            Navigator.pop(context);
            await context.pushNamed(AppRoute.manageLocations.name);
            ref.invalidate(favoriteLocationProvider);
          },
          onReport: () {
            Navigator.pop(context);
            context.pushNamed(AppRoute.reportWrongLocation.name);
          },
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    required this.locationEnabled,
    required this.locationName,
  });

  final bool locationEnabled;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            locationEnabled
                ? Icons.location_on_outlined
                : Icons.location_off_outlined,
            color: Colors.white,
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Text(
              locationName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    required this.favoriteName,
    required this.favoriteTemperature,
    required this.tempSymbol,
    required this.locationEnabled,
    required this.onSettings,
    required this.onManageLocations,
    required this.onReport,
  });

  final String? favoriteName;
  final double? favoriteTemperature;
  final String tempSymbol;
  final bool locationEnabled;
  final VoidCallback onSettings;
  final VoidCallback onManageLocations;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        color: Colors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                tooltip: 'Navigate to settings',
                onPressed: onSettings,
              ),
            ),
            const SizedBox(height: 30.0),
            _FavoriteHeader(),
            const SizedBox(height: 10.0),
            _FavoriteContent(
              name: favoriteName,
              temperature: favoriteTemperature,
              tempSymbol: tempSymbol,
              locationEnabled: locationEnabled,
            ),
            const SizedBox(height: 15.0),
            const DottedLine(dashLength: 2.0, dashColor: Colors.white),
            const SizedBox(height: 15.0),
            const _OtherHeader(),
            const SizedBox(height: 15.0),
            _ManageRow(onTap: onManageLocations),
            const SizedBox(height: 15.0),
            const DottedLine(dashLength: 2.0, dashColor: Colors.white),
            const SizedBox(height: 15.0),
            _ReportRow(onTap: onReport),
          ],
        ),
      ),
    );
  }
}

class _FavoriteHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rate_rounded, size: 35.0, color: Colors.white),
        const SizedBox(width: 8.0),
        const Expanded(
          child: Text(
            'Favourite location',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Tooltip(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          height: MediaQuery.of(context).size.width / 4,
          message: Strings.favouriteLocationDesc,
          textAlign: TextAlign.start,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(milliseconds: 3000),
          child: const Icon(
            Icons.info_outline_rounded,
            size: 24.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _FavoriteContent extends StatelessWidget {
  const _FavoriteContent({
    required this.name,
    required this.temperature,
    required this.tempSymbol,
    required this.locationEnabled,
  });

  final String? name;
  final double? temperature;
  final String tempSymbol;
  final bool locationEnabled;

  @override
  Widget build(BuildContext context) {
    if (name == null) {
      return const Text(
        'Set favorite location.',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
      );
    }
    return Row(
      children: [
        const SizedBox(width: 35.0),
        Icon(
          locationEnabled ? Icons.location_on_rounded : Icons.location_off_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 3.0),
        Expanded(
          child: Text(
            name!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 5.0),
        if (temperature != null)
          Text(
            '${temperature!.toStringAsFixed(0)}$tempSymbol',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    );
  }
}

class _OtherHeader extends StatelessWidget {
  const _OtherHeader();
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.add_location_outlined, color: Colors.white70),
        SizedBox(width: 15.0),
        Expanded(
          child: Text(
            'Other locations',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ManageRow extends StatelessWidget {
  const _ManageRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue.shade100.withValues(alpha: 0.2),
          ),
          child: const Center(
            child: Text(
              'Manage locations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Transform.flip(
                flipY: true,
                child: const Icon(Icons.info_outline, color: Colors.white),
              ),
              const SizedBox(width: 15.0),
              const Expanded(
                child: Text(
                  'Report wrong location',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
