import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/saved_location.dart';

class LocationListItem extends StatelessWidget {
  const LocationListItem({
    super.key,
    required this.location,
    required this.deviceLocationOn,
  });

  final SavedLocation location;
  final bool deviceLocationOn;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (location.isFavorite)
            Icon(deviceLocationOn ? Icons.location_on : Icons.location_off),
          const SizedBox(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
              ),
              Text(
                location.region,
                style: const TextStyle(fontFamily: 'Roboto', color: Colors.grey),
              ),
              Text(
                formatDateTime(DateTime.now()),
                style: const TextStyle(fontFamily: 'Roboto', color: Colors.grey),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          _WeatherInfo(location: location),
        ],
      ),
    );
  }
}

class _WeatherInfo extends StatelessWidget {
  const _WeatherInfo({required this.location});
  final SavedLocation location;

  @override
  Widget build(BuildContext context) {
    final iconUrl =
        'https://openweathermap.org/img/wn/${location.weatherIconId}@2x.png';
    return Column(
      children: [
        Row(
          children: [
            Image.network(iconUrl, errorBuilder: (_, __, ___) => const SizedBox()),
            const SizedBox(width: 5.0),
            Text(
              '${location.currentTemperature.toStringAsFixed(0)}º',
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 20.0),
            ),
          ],
        ),
        Text(
          '${location.maxTemperature.toStringAsFixed(0)}º / '
          '${location.minTemperature.toStringAsFixed(0)}º',
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
      ],
    );
  }
}
