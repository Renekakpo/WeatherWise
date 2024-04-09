import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherDetailsView extends StatelessWidget {

  const WeatherDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
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
          color: Colors.white,
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
              _buildWeatherTempItem(mWidth, headerFont, subHeaderFont),
              const Expanded(child: SizedBox()),
              _buildWeatherWindItem(mWidth, headerFont, subHeaderFont)
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              _buildWeatherUVIndexItem(mWidth, headerFont, subHeaderFont),
              const Expanded(child: SizedBox()),
              _buildWeatherHumidityItem(mWidth, headerFont, subHeaderFont)
            ],
          )
        ]));
  }

  Widget _buildWeatherTempItem(
      double mWidth, TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/icons/thermometer-warmer.json",
              width: mWidth * 0.2, height: mWidth * 0.2),
          // const Icon(Icons.thermostat, size: 40.0, color: Colors.white,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("72º", style: headerFont),
              Text("Celsius", style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherWindItem(
      double mWidth, TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/icons/wind-gust.json",
              width: mWidth * 0.15, height: mWidth * 0.15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("134 km/h", style: headerFont),
              Text("Wind", style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherUVIndexItem(
      double mWidth, TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/icons/sunny.json",
              width: mWidth * 0.2, height: mWidth * 0.2),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("0.2", style: headerFont),
              Text("UV Index", style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeatherHumidityItem(
      double mWidth, TextStyle headerFont, TextStyle subHeaderFont) {
    return Container(
      width: mWidth * 0.4,
      height: mWidth * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/icons/raindrop.json",
              width: mWidth * 0.2, height: mWidth * 0.2),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("48%", style: headerFont),
              Text("Humidity", style: subHeaderFont)
            ],
          )
        ],
      ),
    );
  }
}
