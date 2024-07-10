class Coord {
  final double lon;
  final double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({required this.id, required this.main, required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: int.tryParse(json['id'].toString()) ?? 0,
      main: json['main'].toString(),
      description: json['description'].toString(),
      icon: json['icon'].toString(),
    );
  }
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: double.tryParse(json['temp'].toString()) ?? 0.0,
      feelsLike: double.tryParse(json['feels_like'].toString()) ?? 0.0,
      tempMin: double.tryParse(json['temp_min'].toString()) ?? 0.0,
      tempMax: double.tryParse(json['temp_max'].toString()) ?? 0.0,
      pressure: int.tryParse(json['pressure'].toString()) ?? 0,
      humidity: int.tryParse(json['humidity'].toString()) ?? 0,
      seaLevel: int.tryParse(json['sea_level'].toString()) ?? 0,
      grndLevel: int.tryParse(json['grnd_level'].toString()) ?? 0,
    );
  }
}

class Wind {
  final double speed;
  final int deg;
  final double gust;

  Wind({required this.speed, required this.deg, required this.gust});

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: double.tryParse(json['speed'].toString()) ?? 0.0,
      deg: int.tryParse(json['deg'].toString()) ?? 0,
      gust: double.tryParse(json['gust'].toString()) ?? 0.0,
    );
  }
}

class Sys {
  final String country;
  final int sunrise;
  final int sunset;

  Sys({required this.country, required this.sunrise, required this.sunset});

  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(
      country: json['country'].toString(),
      sunrise: int.tryParse(json['sunrise'].toString()) ?? 0,
      sunset: int.tryParse(json['sunset'].toString()) ?? 0,
    );
  }
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: int.tryParse(json['all'].toString()) ?? 0,
    );
  }
}

class WeatherData {
  final Coord coord;
  final List<Weather> weather;
  final String base;
  final Main main;
  final int visibility;
  final Wind wind;
  final Clouds clouds;
  final int dt;
  final Sys sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  WeatherData({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      coord: Coord.fromJson(json['coord']),
      weather: (json['weather'] as List).map((e) => Weather.fromJson(e)).toList(),
      base: json['base'].toString(),
      main: Main.fromJson(json['main']),
      visibility: int.tryParse(json['visibility'].toString()) ?? 0,
      wind: Wind.fromJson(json['wind']),
      clouds: Clouds.fromJson(json['clouds']),
      dt: int.tryParse(json['dt'].toString()) ?? 0,
      sys: Sys.fromJson(json['sys']),
      timezone: int.tryParse(json['timezone'].toString()) ?? 0,
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'].toString(),
      cod: int.tryParse(json['cod'].toString()) ?? 0,
    );
  }
}