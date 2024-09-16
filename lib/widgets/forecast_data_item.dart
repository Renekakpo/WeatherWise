import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../helpers/utils_helper.dart';
import '../models/forecast_data.dart';

class ForecastDataItem extends StatelessWidget {
  final ForecastItem data;

  const ForecastDataItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double mSize = MediaQuery.of(context).size.width;
    const textStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w500);
    String weatherIconUrl = "https://openweathermap.org/img/wn/${data.weather.first.icon}@2x.png";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            formatTimestampToHour(data.dt),
            style: textStyle,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Image.network(weatherIconUrl, width: mSize * 0.1, height: mSize * 0.1,),
          const SizedBox(
            height: 10.0,
          ),
          Text('${data.main.temp.round()}º', style: textStyle),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/icons/raindrop.json",
                  width: 30.0, height: 30.0),
              Text('${(data.pop * 100).toStringAsFixed(0)}%', style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
