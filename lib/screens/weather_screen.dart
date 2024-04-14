import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/models/forecast_data.dart';
import 'package:weatherwise/models/weather_data.dart';
import 'package:weatherwise/widgets/forecast_tips_card.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      color: const Color(0xFFF8FAFD),
      padding: const EdgeInsets.only(bottom: 10.0),
      // color: backgroundColor,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          _buildMainWeather(context, widget.weatherData),
          _buildMainWeatherForecast(context, getCurrentDateForecast(widget.forecastData.list)),
          const ForecastTipsCard(),
          ForecastCard(forecastItems: groupByDt(widget.forecastData.list)),
          WeatherDetailsView(weatherData: widget.weatherData)
        ],
      ),
    ));
  }
}

Widget _buildMainWeather(
    BuildContext context, WeatherData weatherData) {
  double mSize = MediaQuery.of(context).size.width;

  return Container(
    width: mSize,
    margin:
        const EdgeInsets.only(top: 25.0, bottom: 10.0, left: 25.0, right: 25.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        color: Colors.white,
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
              "${weatherData.main.temp.round()}",
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              weatherData.weather.first.main,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "${weatherData.main.tempMax.round()}º / ${weatherData.main.tempMin.round()}º Feels like ${weatherData.main.feelsLike.round()}º",
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        SizedBox(
          width: mSize * 0.1,
        ),
        Expanded(
            child: Lottie.asset("assets/icons/${weatherData.weather.first.main.toLowerCase().replaceAll(" ", "-")}.json",
                width: mSize * 0.4, height: mSize * 0.4))
      ],
    ),
  );
}

Widget _buildMainWeatherForecast(BuildContext context, List<ForecastItem> currentForecastItems) {
  return Container(
    width: double.infinity,
    margin:
        const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
    padding: const EdgeInsets.all(15.0),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2))
        ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Partly cloudy. Lows 26ºC.",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14.0,
          ),
        ),
        const Divider(
          color: Colors.black54,
          thickness: 0.5,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.width / 3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: currentForecastItems.length,
              itemBuilder: (context, index) {
                return ForecastDataItem(data: currentForecastItems[index]);
              },
            ))
      ],
    ),
  );
}
