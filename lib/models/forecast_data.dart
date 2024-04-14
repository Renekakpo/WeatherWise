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
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: json['all'],
    );
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
      speed: json['speed'],
      deg: json['deg'],
      gust: json['gust'].toDouble(),
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
}

List<ForecastItem> groupByDt(List<ForecastItem> forecastItems) {
  final Map<String, ForecastItem> groupedItems = {};

  // Group items by dt
  for (final item in forecastItems) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000); // Convert dt to DateTime
    final date = DateFormat('yyyy-MM-dd').format(dateTime); // Format DateTime as 'yyyy-MM-dd' string
    if (!groupedItems.containsKey(date)) {
      groupedItems[date] = (item);
    }
  }

  var res = groupedItems.values.toList();

  // Flatten the grouped items
  return res;
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