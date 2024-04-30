import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const String API_KEY = "05f7a4deffba0f4d53ad6a094e26ad51";

String formatDateTime(DateTime dateTime) {
  return DateFormat('E, d MMM H:mm').format(dateTime);
}

String getDayNameFromTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  // Format the date to get the day name
  String dayName = DateFormat('EEEE').format(date);
  return dayName;
}

String formatTimestampToHour(int timestamp) {
  // Create a DateTime object from the timestamp
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();

  // Check if the minutes are zero
  if (dateTime.minute == 0) {
    // If minutes are zero, return hour without minutes
    return DateFormat.jm().format(dateTime);
  } else {
    // If minutes are non-zero, return hour with minutes
    return DateFormat('h:mm a').format(dateTime);
  }
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

Future myLoadAsset(String path) async {
  try {
    // Load the asset bundle
    AssetBundle bundle = rootBundle;

    // Check if the asset exists
    bool exists = await bundle.load(path).then((value) => true).catchError((error) => false);

    // If asset exists, return the path
    if (exists) {
      return path;
    } else {
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}