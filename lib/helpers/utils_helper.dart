import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('E, d MMM H:mm').format(dateTime);
}

String getDayNameFromTimestamp(int timestamp) {
  DateTime date =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
  // Format the date to get the day name
  String dayName = DateFormat('EEEE').format(date);
  return dayName;
}

String formatTimestampToHour(int timestamp) {
  // Create a DateTime object from the timestamp
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();

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

  switch (type.toLowerCase()) {
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

  switch (type.toLowerCase()) {
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

Future<String?> myLoadAsset(String path, {AssetBundle? assetBundle}) async {
  try {
    // Load the asset bundle
    AssetBundle bundle;
    if (assetBundle != null) {
      bundle = assetBundle;
    } else {
      bundle = rootBundle;
    }

    // Check if the asset exists
    bool exists = await bundle
        .load(path)
        .then((value) => true)
        .catchError((error) => false);

    // If asset exists, return the path
    if (exists) {
      return path;
    } else {
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
    return null;
  }
}

String getWeatherDescription(double temperature) {
  if (temperature < 0) {
    return "It's freezing outside! Bundle up warmly.";
  } else if (temperature >= 0 && temperature < 10) {
    return "It's quite cold. Don't forget your jacket.";
  } else if (temperature >= 10 && temperature < 20) {
    return "It's cool outside. A light sweater should be enough.";
  } else if (temperature >= 20 && temperature < 30) {
    return "The weather is warm and pleasant.";
  } else if (temperature >= 30 && temperature < 40) {
    return "It's hot outside! Stay hydrated.";
  } else if (temperature >= 40) {
    return "It's extremely hot! Avoid going out if possible.";
  } else {
    return "Temperature out of range.";
  }
}

double convertFromMeterToKilometer(bool isWeatherUnit, double windSpeed) {
  try {
    if (!isWeatherUnit) {
      // When isWeatherUnit false(Celsius), unit is metric and wind speed in meters per second
      // Convert wind speed from meters per second to kilometers per hour
      return windSpeed * 3.6;
    } else {
      // When isWeatherUnit true(Fahrenheit), unit is imperial and wind speed in miles per second
      // Convert wind speed from miles per second to kilo miles per hour
      return (windSpeed * 3600) /
          1000; // 3600 to convert seconds to hours, then divide by 1000 for kilo miles
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return windSpeed; // Return default windSpeed if error
}
