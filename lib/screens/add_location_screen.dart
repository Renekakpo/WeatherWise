import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:weatherwise/utils/wcolors.dart';

import '../helpers/database_helper.dart';
import '../helpers/shared_preferences_helper.dart';
import '../models/manage_location.dart';
import '../network/weather_api_helper.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _cities = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final WeatherApiHelper _weatherApiHelper = WeatherApiHelper(dotenv.env['WEATHER_WISE_API_KEY'] ?? "");
  bool _isLoading = false;
  String units = "metric";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();

    loadUnits();
  }

  void _onBackArrowPressed() {
    Navigator.pop(context);
  }

  void updateLoaderState(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> loadUnits() async {
    setState(() {
      bool unit = AppSharedPreferences().getWeatherUnit();
      // Imperial gives temp in Fahrenheit and wind speed in miles/h
      // while metric gives temp in Celsius and wind speed in m/s
      units = unit ? "imperial" : "metric";
    });
  }

  Future<void> _searchCities(String query) async {
    final response = await http.get(Uri.parse(
        'http://api.geonames.org/searchJSON?q=$query&maxRows=10&username=anukus'));

    if (response.statusCode == 200) {
      final List<dynamic> cities = json.decode(response.body)['geonames'];
      final Set<String> cityNames = {};
      final List<dynamic> uniqueCities = [];

      for (var city in cities) {
        if (!cityNames.contains(city['name'])) {
          cityNames.add(city['name']);
          uniqueCities.add(city);
        }
      }

      setState(() {
        _cities = uniqueCities;
      });
    } else {
      errorMessage = "Failed to load cities";
      updateLoaderState(false);
    }
  }

  Future<void> _fetchWeatherAndSaveLocation(
      String region, double lat, double lng) async {
    try {
      // Display loader and prevent user from touching the view
      updateLoaderState(true);

      // Fetch weather data for the selected location
      final weatherData = await _weatherApiHelper.getCurrentWeatherData(lat, lng, units);

      // If there is data, initialized a ManageLocation object
      if (weatherData != null) {
        final location = ManageLocation(
          name: weatherData.name,
          region: region,
          latitude: weatherData.coord.lat,
          longitude: weatherData.coord.lon,
          isFavorite: false,
          useDeviceLocation: false,
          weatherCondition: weatherData.weather.first.main,
          weatherIconId: weatherData.weather.first.icon,
          currentTemperature: weatherData.main.temp,
          minTemperature: weatherData.main.tempMin,
          maxTemperature: weatherData.main.tempMax,
        );

        // Save the object to the local database
        await _databaseHelper.insertLocation(location);

        // Navigate back
        _onBackArrowPressed();
      } else {
        // Display errorMessage
        errorMessage = "Failed to fetch weather data!";
        // Remove loader
        updateLoaderState(false);
      }
    } catch(e) {
      // Display errorMessage
      errorMessage = "Error: ${e.toString()}";
      // Remove loader
      updateLoaderState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (!_isLoading) {
              _onBackArrowPressed();
            }
          },
        ),
        title: TextField(
            controller: _controller,
            decoration: const InputDecoration(
                border: InputBorder.none, hintText: "Search"),
            style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.normal),
            textAlignVertical: TextAlignVertical.center,
            readOnly: _isLoading,
            onChanged: (value) {
              if (value.isNotEmpty) {
                _searchCities(value);
              } else {
                setState(() {
                  _cities = [];
                });
              }
            }),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset("assets/icons/loader_animation.json",
                  width: 120.0, height: 120.0))
          : _cities.isEmpty
              ? Center(
                  child: Text(errorMessage.isEmpty ? "Enter a location name." : errorMessage,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500)),
                )
              : ListView.separated(
                  itemCount: _cities.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (context, index) {
                    final city = _cities[index];
                    return ListTile(
                      title: Text(city['name']),
                      subtitle: Text(
                          "${city['adminName1'].isNotEmpty ? city['adminName1'] + ", " : ""}${city['countryName'] ?? ""}"),
                      onTap: () {
                        _fetchWeatherAndSaveLocation(
                            city['adminName1'],
                            double.tryParse(city['lat'].toString()) ?? 0.0,
                            double.tryParse(city['lng'].toString()) ?? 0.0);
                      }, // (${city['lat']}, ${city['lng']})
                    );
                  },
                ),
    );
  }
}
