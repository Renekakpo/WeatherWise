import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String openWeatherApiKey = "05f7a4deffba0f4d53ad6a094e26ad51";

String formatDateTime(DateTime dateTime) {
  return DateFormat('E, d MMM H:mm').format(dateTime);
}

String iconPathFromWeatherType(String type) {
  String iconPath = "assets/vectors/icons/";

  switch(type.toLowerCase()) {
    case "cloudy":
      iconPath += "cloudy.svg";
      break;
    case "moonfull":
      iconPath += "moon-full.svg";
      break;
    case "sunrise":
      iconPath += "sunrise.svg";
      break;
    case "sunset":
      iconPath += "sunset.svg";
      break;
    case "sunny":
      iconPath += "sunrise.svg";
      break;
    default:
      iconPath += "fog-day.svg";
      break;
  }

  return iconPath;
}

IconData iconDataFromWeatherType(String type) {
  IconData iconData;

  switch(type.toLowerCase()) {
    case "cloudy":
      iconData = Icons.wb_cloudy;
      break;
    case "moonfull":
      iconData = Icons.wb_cloudy_outlined;
      break;
    case "sunrise":
      iconData = Icons.wb_sunny;
      break;
    case "sunset":
      iconData = Icons.wb_sunny_outlined;
      break;
    case "sunny":
      iconData = Icons.wb_sunny;
      break;
    default:
      iconData = Icons.wb_twilight;
      break;
  }

  return iconData;
}