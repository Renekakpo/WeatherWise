import 'package:flutter/material.dart';
import 'package:weatherwise/models/forecast_data.dart';

import '../helpers/utils_helper.dart';

class ForecastCard extends StatefulWidget {

  final List<ForecastItem> forecastItems;

  const ForecastCard({super.key, required this.forecastItems});

  @override
  State<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
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
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.57,
          child: ListView.builder(
            itemCount: widget.forecastItems.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildForecastItem(index, widget.forecastItems[index]);
            },
          )),
    );
  }
}

Widget _buildForecastItem(int index, ForecastItem forecastItem) {
  var itemColor = (index == 0) ? Colors.grey : Colors.black;

  return Container(
    margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 3.0, bottom: 1.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(getDayNameFromTimestamp(forecastItem.dt),
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: itemColor)),
        const Expanded(child: SizedBox()),
        Icon(
          Icons.water_drop,
          size: 14.0,
          color: itemColor,
        ),
        const SizedBox(width: 3.0,),
        Text(
          '${(forecastItem.pop * 100).toStringAsFixed(0)}%',
          style: TextStyle(
              fontSize: 13.0, fontWeight: FontWeight.w400, color: itemColor),
        ),
        const SizedBox(width: 15.0,),
        Icon(iconDataFromWeatherType(forecastItem.weather.first.main.toLowerCase()), color: itemColor,),
        const SizedBox(width: 15.0,),
        Icon(iconDataFromWeatherType(forecastItem.weather.first.main.toLowerCase()), color: itemColor,),
        const SizedBox(width: 15.0),
        Text(
          '${forecastItem.main.tempMax.round()}º ',
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w700, color: itemColor),
        ),
        const SizedBox(width: 15.0,),
        Text(
          '${forecastItem.main.tempMin.round()}º',
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w700, color: itemColor),
        ),
      ],
    ),
  );
}
