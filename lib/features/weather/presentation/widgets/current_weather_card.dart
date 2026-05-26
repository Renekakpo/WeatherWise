import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/weather.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      margin: const EdgeInsets.only(top: 25.0, bottom: 10.0, left: 25.0, right: 25.0),
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: WColors.blueGray300,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${weather.temperature.round()}º',
                key: const Key('main_temperature'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                weather.condition,
                key: const Key('main_condition'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                '${weather.tempMax.round()}º / ${weather.tempMin.round()}º '
                'Feels like ${weather.feelsLike.round()}º',
                key: const Key('min_and_max_temperature'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Image.network(
            weather.iconUrl,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}
