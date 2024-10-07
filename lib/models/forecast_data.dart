import 'package:intl/intl.dart';

class ForecastData {
  final String cod;
  final int message;
  final int cnt;
  final List<ForecastItem> list;
  final City city;

  ForecastData({
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      cod: json['cod'],
      message: json['message'],
      cnt: json['cnt'],
      list: (json['list'] as List<dynamic>)
          .map((item) => ForecastItem.fromJson(item))
          .toList(),
      city: City.fromJson(json['city']),
    );
  }

  // Factory to create a fake instance for testing
  factory ForecastData.fake() {
    return ForecastData(
      cod: "200",
      message: 0,
      cnt: 5,
      list: List.generate(5, (index) => ForecastItem.fake()), // Generate 5 forecast items
      city: City.fake(),
    );
  }
}

class ForecastItem {
  final int dt;
  final Main main;
  final List<Weather> weather;
  final Clouds clouds;
  final Wind wind;
  final int visibility;
  final double pop;
  final Sys sys;
  final String dtTxt;

  ForecastItem({
    required this.dt,
    required this.main,
    required this.weather,
    required this.clouds,
    required this.wind,
    required this.visibility,
    required this.pop,
    required this.sys,
    required this.dtTxt,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dt: json['dt'],
      main: Main.fromJson(json['main']),
      weather: (json['weather'] as List<dynamic>)
          .map((item) => Weather.fromJson(item))
          .toList(),
      clouds: Clouds.fromJson(json['clouds']),
      wind: Wind.fromJson(json['wind']),
      visibility: json['visibility'],
      pop: json['pop'].toDouble(),
      sys: Sys.fromJson(json['sys']),
      dtTxt: json['dt_txt'],
    );
  }

  factory ForecastItem.fake() {
    return ForecastItem(
      dt: 1628123456, // A sample UNIX timestamp
      main: Main.fake(),
      weather: List.generate(1, (index) => Weather.fake()), // Single weather item
      clouds: Clouds.fake(),
      wind: Wind.fake(),
      visibility: 10000, // Visibility in meters
      pop: 0.75, // Probability of precipitation
      sys: Sys.fake(),
      dtTxt: "2024-10-01 12:00:00", // Sample date in "YYYY-MM-DD HH:mm:ss" format
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int seaLevel;
  final int grndLevel;
  final int humidity;
  final int tempKf;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.seaLevel,
    required this.grndLevel,
    required this.humidity,
    required this.tempKf,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      tempMax: json['temp_max'].toDouble(),
      pressure: json['pressure'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
      humidity: json['humidity'],
      tempKf: (json['temp_kf'] ?? 0).toInt(),
    );
  }

  factory Main.fake() {
    return Main(
      temp: 298.15, // Temperature in Kelvin
      feelsLike: 300.15,
      tempMin: 295.15,
      tempMax: 303.15,
      pressure: 1013, // Pressure in hPa
      seaLevel: 1013,
      grndLevel: 1008,
      humidity: 85, // Humidity percentage
      tempKf: 0,
    );
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  factory Weather.fake() {
    return Weather(
      id: 800,
      main: "Clear",
      description: "clear sky",
      icon: "01d", // Icon code
    );
  }
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
  }

  factory Clouds.fake() {
    return Clouds(all: 10);
  }
}

class Wind {
  final double speed;
  final int deg;
  final double gust;

  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json['speed'].toDouble(),
      deg: json['deg'].toInt(),
      gust: json['gust'].toDouble(),
    );
  }

  factory Wind.fake() {
    return Wind(
      speed: 5.5, // Wind speed in m/s
      deg: 180, // Wind direction in degrees
      gust: 7.5, // Wind gust speed
    );
  }
}

class Sys {
  final String pod;

  Sys({required this.pod});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      pod: json['pod'],
    );
  }

  factory Sys.fake() {
    return Sys(pod: "d");
  }
}

class City {
  final int id;
  final String name;
  final Coord coord;
  final String country;
  final int population;
  final int timezone;
  final int sunrise;
  final int sunset;

  City({
    required this.id,
    required this.name,
    required this.coord,
    required this.country,
    required this.population,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      coord: Coord.fromJson(json['coord']),
      country: json['country'],
      population: json['population'],
      timezone: json['timezone'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  factory City.fake() {
    return City(
      id: 12345,
      name: "Sample City",
      coord: Coord.fake(),
      country: "US",
      population: 500000,
      timezone: -14400, // Timezone offset in seconds
      sunrise: 1628053200, // Sample UNIX timestamp for sunrise
      sunset: 1628103600, // Sample UNIX timestamp for sunset
    );
  }
}

class Coord {
  final double lat;
  final double lon;

  Coord({required this.lat, required this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  factory Coord.fake() {
    return Coord(
      lat: 40.7128, // Latitude for New York, for example
      lon: -74.0060, // Longitude for New York
    );
  }
}

Map<String, List<ForecastItem>> groupByDt(List<ForecastItem> forecastItems) {
  final Map<String, List<ForecastItem>> groupedItems = {};

  // Group items by dt
  for (final item in forecastItems) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000); // Convert dt to DateTime
    final date = DateFormat('yyyy-MM-dd').format(dateTime); // Format DateTime as 'yyyy-MM-dd' string
    if (!groupedItems.containsKey(date)) {
      groupedItems[date] = [item];
    } else {
      groupedItems[date]?.add(item);
    }
  }

  var res = groupedItems.values.toList();

  // Flatten the grouped items
  return groupedItems;
}

List<ForecastItem> getCurrentDateForecast(List<ForecastItem> forecastItems) {
  // Get current date
  DateTime currentDate = DateTime.now();

  // Filter forecast items for the current date
  List<ForecastItem> currentForecast = forecastItems.where((item) {
    // Convert dt to DateTime
    DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
    // Check if the item date matches the current date
    return itemDate.year == currentDate.year &&
        itemDate.month == currentDate.month &&
        itemDate.day == currentDate.day;
  }).toList();

  // Sort forecast items in ascending order based on dt
  currentForecast.sort((a, b) => a.dt.compareTo(b.dt));

  return currentForecast;
}