import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../helpers/utils_helper.dart';
import '../models/forecast_data.dart';

class ForecastDataItem extends StatelessWidget {
  final ForecastItem data;
  const ForecastDataItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.black87, fontWeight: FontWeight.w500);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(formatTimestampToHour(data.dt), style: textStyle,),
          const SizedBox(height: 10.0,),
          Lottie.asset("assets/icons/overcast-rain.json", width: 25.0, height: 25.0),
          // Icon(iconDataFromWeatherType(data.weatherType), color: Colors.white,),
          const SizedBox(height: 10.0,),
          Text('${data.main.temp.round()}º', style: textStyle),
          const SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/icons/raindrop.json", width: 25.0, height: 25.0),
              Text('${(data.pop * 100).toStringAsFixed(0)}%', style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
