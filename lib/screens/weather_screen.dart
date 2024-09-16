import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/helpers/shared_preferences_helper.dart';
import 'package:weatherwise/helpers/utils_helper.dart';
import 'package:weatherwise/models/forecast_data.dart';
import 'package:weatherwise/models/weather_data.dart';
import 'package:weatherwise/utils/wcolors.dart';
import 'package:weatherwise/widgets/forecast_tips_card.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/notification_helper.dart';
import '../widgets/forecast_card.dart';
import '../widgets/forecast_data_item.dart';
import '../widgets/weather_details_view.dart';

class WeatherScreen extends StatefulWidget {
  final WeatherData weatherData;
  final ForecastData forecastData;

  const WeatherScreen(
      {super.key, required this.weatherData, required this.forecastData});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  var backgroundColor = Colors.blueGrey;
  String weatherUnit = AppSharedPreferences().getWeatherUnit() ? "ºF" : "ºC";
  String notificationBody = "";

  Future<void> showWeatherUpdate(
      String title, String body, String iconUrl) async {
    if (await Permission.notification.isGranted) {
      NotificationHelper().showWeatherNotification(
        title: title,
        body: body,
        weatherIconUrl: iconUrl,
        notificationId: 1,
      );
    } else {
      // Handle permission denial
      if (kDebugMode) {
        print("Notification permission denied");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final title = widget.weatherData.name; // City name
    final body =
        'Today feels like ${widget.weatherData.main.feelsLike.round()}$weatherUnit.\n${getWeatherDescription(widget.weatherData.main.feelsLike)}';
    final iconUrl =
        "https://openweathermap.org/img/wn/${widget.weatherData.weather.first.icon}@2x.png";

    showWeatherUpdate(title, body, iconUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(
          color: WColors.blueGray500 /*const Color(0xFFF8FAFD)*/,
          padding: const EdgeInsets.only(bottom: 10.0),
          // color: backgroundColor,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              _buildMainWeather(context, widget.weatherData),
              const SizedBox(
                height: 20.0,
              ),
              ForecastCard(forecastItems: groupByDt(widget.forecastData.list)),
              const SizedBox(
                height: 20.0,
              ),
              _buildSunStateWidget(context, widget.weatherData),
              const SizedBox(
                height: 20.0,
              ),
              WeatherDetailsView(weatherData: widget.weatherData)
            ],
          ),
        ));
  }


}

Widget _buildMainWeather(BuildContext context, WeatherData weatherData) {
  double mSize = MediaQuery.of(context).size.width;
  String iconId = weatherData.weather.first.icon;
  String weatherIconUrl = "https://openweathermap.org/img/wn/$iconId@2x.png";

  return Container(
    width: mSize,
    margin:
        const EdgeInsets.only(top: 25.0, bottom: 10.0, left: 25.0, right: 25.0),
    padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
    decoration: BoxDecoration(
        color: WColors.blueGray300,
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ]),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${weatherData.main.temp.round()}º",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              weatherData.weather.first.main,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "${weatherData.main.tempMax.round()}º / ${weatherData.main.tempMin.round()}º Feels like ${weatherData.main.feelsLike.round()}º",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        const Expanded(child: SizedBox()),
        Image.network(weatherIconUrl)
      ],
    ),
  );
}

Widget _buildSunStateWidget(BuildContext context, WeatherData weatherData) {
  double mSize = MediaQuery.of(context).size.width;
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(10.0),
      color: WColors.blueGray300,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(formatTimestampToHour(weatherData.sys.sunrise),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                )),
            Lottie.asset("assets/icons/sunrise.json",
                width: mSize * 0.25,
                height: mSize * 0.25,
                fit: BoxFit.cover,
                alignment: Alignment.center),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(formatTimestampToHour(weatherData.sys.sunset),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                )),
            Lottie.asset("assets/icons/sunset.json",
                width: mSize * 0.25,
                height: mSize * 0.25,
                fit: BoxFit.fill,
                alignment: Alignment.center),
          ],
        )
      ],
    ),
  );
}
