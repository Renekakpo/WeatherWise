import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/widgets/forecast_tips_card.dart';

import '../helpers/WeatherApiHelper.dart';
import '../helpers/fake_data.dart';
import '../helpers/utils_helper.dart';
import '../widgets/forecast_card.dart';
import '../widgets/forecast_data_item.dart';
import '../widgets/weather_details_view.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  var backgroundColor = Colors.blueGrey;

  final WeatherApiHelper weatherApiHelper = WeatherApiHelper(openWeatherApiKey);

  @override
  void initState() {
    super.initState();
    // Call the method to fetch weather data
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      // Example: Fetch weather data for a specific location
      Map<String, dynamic> weatherData =
          await weatherApiHelper.getCurrentWeather(37.7749, -122.4194);
      // Handle the weather data as needed
      print(weatherData);
    } catch (e) {
      // Handle errors
      print("Error fetching weather data: $e");
    }
  }

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
          _buildCurrentForecast(context),
          _buildWeatherData(context),
          const ForecastTipsCard(),
          const ForecastCard(),
          const WeatherDetailsView()
        ],
      ),
    ));
  }
}

Widget _buildCurrentForecast(BuildContext context) {
  double mSize = MediaQuery.of(context).size.width;
  int temp = 32;

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
              "$tempº",
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 60.0,
                  fontWeight: FontWeight.w500),
            ),
            const Text(
              "Haze",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "${temp + 10}º / ${temp - 10}º Feels like ${temp + 8}º",
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
            child: Lottie.asset("assets/icons/rain-night.json",
                width: mSize * 0.4, height: mSize * 0.4))
      ],
    ),
  );
}

Widget _buildWeatherData(BuildContext context) {
  final forecastData = generateDummyData();

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
              fontSize: 14.0,),
        ),
        const Divider(
          color: Colors.black54,
          thickness: 0.5,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.width / 3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecastData.length,
              itemBuilder: (context, index) {
                return ForecastDataItem(data: forecastData[index]);
              },
            ))
      ],
    ),
  );
}
