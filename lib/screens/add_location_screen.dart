import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/helpers/utils_helper.dart';

import '../helpers/DatabaseHelper.dart';
import '../models/manage_location.dart';
import '../network/WeatherApiHelper.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _cities = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final WeatherApiHelper _weatherApiHelper = WeatherApiHelper(API_KEY);
  bool _isLoading = false;

  void _onBackArrowPressed() {
    Navigator.pop(context);
  }

  void updateLoaderState(bool state) {
    setState(() {
      _isLoading = state;
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
      throw Exception('Failed to load cities');
    }
  }

  Future<void> _fetchWeatherAndSaveLocation(
      String region, double lat, double lng) async {
    // Display loader and prevent user from touching the view
    updateLoaderState(true);

    // Fetch weather data for the selected location
    final weatherData = await _weatherApiHelper.getCurrentWeatherData(lat, lng);

    // If there is data, initialized a ManageLocation object
    if (weatherData != null) {
      final location = ManageLocation(
        name: weatherData.name,
        region: region,
        isFavorite: false,
        useDeviceLocation: false,
        weatherCondition: weatherData.weather.first.main,
        currentTemperature: weatherData.main.temp,
        minTemperature: weatherData.main.tempMin,
        maxTemperature: weatherData.main.tempMax,
      );

      // Save the object to the local database
      await _databaseHelper.insertLocation(location);

      // Navigate back
      _onBackArrowPressed();
    } else {
      print("No weather data found.");
      // Remove loader
      updateLoaderState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFD),
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
              ? const Center(
                  child: Text("Enter a location name.",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
