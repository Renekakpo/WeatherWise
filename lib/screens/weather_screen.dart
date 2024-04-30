import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/helpers/utils_helper.dart';
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

  return Container(
    width: mSize,
    margin:
        const EdgeInsets.only(top: 25.0, bottom: 10.0, left: 25.0, right: 25.0),
    padding: const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
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
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "${weatherData.main.tempMax.round()}º / ${weatherData.main.tempMin.round()}º Feels like ${weatherData.main.feelsLike.round()}º",
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
        SizedBox(
          width: mSize * 0.1,
        ),
        FutureBuilder(
            future: myLoadAsset(
                "assets/icons/${weatherData.weather.first.main.toLowerCase().replaceAll(" ", "-")}.json"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading widget while the future is resolving
                return const CircularProgressIndicator(); // Or any other loading indicator
              } else if (snapshot.hasError) {
                // Handle error case if necessary
                return Text('Error: ${snapshot.error}');
              } else {
                // If the future has resolved successfully
                final assetPath = snapshot.data;
                if (assetPath != null) {
                  // If assetPath is not null, display the Lottie animation
                  return Expanded(
                    child: Lottie.asset(
                      assetPath,
                      width: mSize * 0.4,
                      height: mSize * 0.4,
                      backgroundLoading: true,
                      filterQuality: FilterQuality.high,
                    ),
                  );
                } else {
                  // If assetPath is null, don't display anything
                  return const SizedBox(); // or any other empty widget
                }
              }
            }),
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
      color: Colors.white,
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
                  color: Colors.black87,
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
                  color: Colors.black87,
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

Widget _buildMainWeatherForecast(
    BuildContext context, List<ForecastItem> currentForecastItems) {
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
