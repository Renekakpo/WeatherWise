import 'package:flutter/material.dart';
import 'package:weatherwise/models/weather_data.dart';
import 'package:weatherwise/utils/strings.dart';

import '../helpers/shared_preferences_helper.dart';
import '../helpers/utils_helper.dart';
import '../utils/wcolors.dart';

class WeatherDetailsView extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetailsView({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    bool weatherUnit = AppSharedPreferences().getWeatherUnit();
    const headerFont = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white);
    const subHeaderFont = TextStyle(
        fontWeight: FontWeight.w400, fontSize: 14.0, color: Colors.white70);

    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          color: WColors.blueGray300,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: [
          Row(
            children: [
              _buildWeatherTempItem(weatherData.main.temp.toInt(), mWidth,
                  headerFont, subHeaderFont),
              const Expanded(child: SizedBox()),
              _buildWeatherWindItem(
                  convertFromMeterToKilometer(
                          weatherUnit, weatherData.wind.speed)
                      .round(),
                  mWidth,
                  headerFont,
                  subHeaderFont)
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              _buildWeatherUVIndexItem(
                  weatherData.main.pressure, mWidth, headerFont, subHeaderFont),
              const Expanded(child: SizedBox()),
              _buildWeatherHumidityItem(
                  weatherData.main.humidity, mWidth, headerFont, subHeaderFont)
            ],
          )
        ]));
  }

  Widget _buildWeatherTempItem(
      int temp, double mWidth, TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: WColors.blueGray200,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/weather_temp.png",
            width: mWidth * 0.1,
            height: mWidth * 0.1,
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$tempº", style: headerFont),
              Text(
                  AppSharedPreferences().getWeatherUnit()
                      ? Strings.fahrenheit
                      : Strings.celsius,
                  style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherWindItem(int windSpeed, double mWidth,
      TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: WColors.blueGray200,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/weather_wind.png",
            width: mWidth * 0.1,
            height: mWidth * 0.1,
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppSharedPreferences().getWeatherUnit() ? "$windSpeed kmiles/h" : "$windSpeed km/h", style: headerFont),
              Text("Wind", style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherUVIndexItem(int pressure, double mWidth,
      TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: WColors.blueGray200,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/weather_pressure.png',
            width: mWidth * 0.1,
            height: mWidth * 0.1,
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$pressure", style: headerFont),
              Text("Pressure", style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherHumidityItem(int humidity, double mWidth,
      TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: WColors.blueGray200,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/weather_humidity.png",
            width: mWidth * 0.08,
            height: mWidth * 0.08,
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$humidity%", style: headerFont),
              Text("Humidity", style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }
}
