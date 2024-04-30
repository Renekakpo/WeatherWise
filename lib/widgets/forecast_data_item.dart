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
        TextStyle(color: Colors.black87, fontWeight: FontWeight.w500);

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
          FutureBuilder(
              future: myLoadAsset(
                  "assets/icons/${data.weather.first.main.toLowerCase().replaceAll(" ", "-")}.json"),
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
                        width: mSize * 0.05,
                        height: mSize * 0.05,
                        backgroundLoading: true,
                        filterQuality: FilterQuality.high,
                      ),
                    );
                  } else {
                    // If assetPath is null, don't display anything
                    return const Expanded(child: SizedBox()); // or any other empty widget
                  }
                }
              }),
          // Icon(iconDataFromWeatherType(data.weatherType), color: Colors.white,),
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
                  width: 25.0, height: 25.0),
              Text('${(data.pop * 100).toStringAsFixed(0)}%', style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
