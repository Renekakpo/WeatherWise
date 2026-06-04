import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/utils/unit_converter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../settings/domain/entities/temperature_unit.dart';
import '../../domain/entities/weather.dart';

class WeatherDetailsCard extends StatelessWidget {
  const WeatherDetailsCard({
    super.key,
    required this.weather,
    required this.unit,
  });

  final Weather weather;
  final TemperatureUnit unit;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const headerFont = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: Colors.white,
    );
    const subHeaderFont = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      color: Colors.white70,
    );

    final temp = weather.temperature.toInt();
    final wind =
        convertFromMeterToKilometer(unit.isImperial, weather.windSpeed).round();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: WColors.blueGray300,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Tile(
                width: width,
                asset: 'assets/images/weather_temp.png',
                header: '$tempº',
                subHeader: unit.isImperial ? Strings.fahrenheit : Strings.celsius,
                headerFont: headerFont,
                subHeaderFont: subHeaderFont,
              ),
              const Expanded(child: SizedBox()),
              _Tile(
                width: width,
                asset: 'assets/images/weather_wind.png',
                header: unit.isImperial ? '$wind kmiles/h' : '$wind km/h',
                subHeader: 'Wind',
                headerFont: headerFont,
                subHeaderFont: subHeaderFont,
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              _Tile(
                width: width,
                asset: 'assets/images/weather_pressure.png',
                header: '${weather.pressure}',
                subHeader: 'Pressure',
                headerFont: headerFont,
                subHeaderFont: subHeaderFont,
              ),
              const Expanded(child: SizedBox()),
              _Tile(
                width: width,
                asset: 'assets/images/weather_humidity.png',
                header: '${weather.humidity}%',
                subHeader: 'Humidity',
                headerFont: headerFont,
                subHeaderFont: subHeaderFont,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.width,
    required this.asset,
    required this.header,
    required this.subHeader,
    required this.headerFont,
    required this.subHeaderFont,
  });
  final double width;
  final String asset;
  final String header;
  final String subHeader;
  final TextStyle headerFont;
  final TextStyle subHeaderFont;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.4,
      height: width * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: WColors.blueGray200,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(asset, width: width * 0.1, height: width * 0.1, color: Colors.white),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(header, style: headerFont),
              Text(subHeader, style: subHeaderFont),
            ],
          ),
        ],
      ),
    );
  }
}
