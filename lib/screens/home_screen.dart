import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherwise/helpers/location_helper.dart';
import 'package:weatherwise/helpers/internet_helper.dart';
import 'package:weatherwise/models/forecast_data.dart';
import 'package:weatherwise/models/manage_location.dart';
import 'package:weatherwise/screens/manage_locations_screen.dart';
import 'package:weatherwise/screens/report_wrong_location.dart';
import 'package:weatherwise/screens/settings_screen.dart';
import 'package:weatherwise/screens/weather_screen.dart';
import 'package:weatherwise/utils/strings.dart';

import '../helpers/database_helper.dart';
import '../helpers/shared_preferences_helper.dart';
import '../models/weather_data.dart';
import '../network/weather_api_helper.dart';
import '../utils/wcolors.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  final AppSharedPreferences preferences;
  final WeatherApiHelper? weatherApiHelper;
  final LocationHelper? locationHelper;

  const HomeScreen(
      {super.key,
      required this.databaseHelper,
      required this.preferences,
      this.weatherApiHelper,
      this.locationHelper});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WeatherApiHelper weatherApiHelper;
  Position? _currentPosition;
  WeatherData? _weatherData;
  ForecastData? _forecastData;
  bool _locationEnabled = false;
  ManageLocation? _favoriteLocation;
  late StreamSubscription<ServiceStatus> _locationServiceStream;
  bool _weatherUnit = false; // false: Celsius, true: Fahrenheit
  String units = "metric";
  late Widget _body;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    try {
      weatherApiHelper = widget.weatherApiHelper ??
          WeatherApiHelper(dotenv.env['WEATHER_WISE_API_KEY'] ?? "");
      _body = _buildLottieLoader();
      _locationServiceStream =
          Geolocator.getServiceStatusStream().listen((event) async {
        setState(() {
          _locationEnabled =
              (event == ServiceStatus.enabled); // Save location service state
        });

        if (_locationEnabled) {
          // Display loader
          setState(() {
            _body = _buildLottieLoader();
          });
          // Get current location
          _currentPosition = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          if (_currentPosition != null) {
            _getWeatherDetailsWithCurrentLocation();
          }
        } else {
          if (_favoriteLocation != null) {
            // Display loader
            setState(() {
              _body = _buildLottieLoader();
            });
            _getWeatherDetailsWithFavoriteLocation();
          }
          _showExplanationDialogForLocationService();
        }
      });

      readFavoriteLocationFromLocalDatabase();
      _readWeatherUnitsFromPreferences();
      _initLocationServiceState();
    } catch (e) {
      if (kDebugMode) {
        print("HomeScreen initState: ${e.toString()}");
      }
    }
  }

  Widget _buildLottieLoader() {
    return Center(
        key: const Key('lottie loader'),
        child: Lottie.asset("assets/icons/loader_animation.json",
            width: 120.0, height: 120.0));
  }

  void _initLocationServiceState() async {
    _locationEnabled = await (widget.locationHelper ?? LocationHelper()).isLocationServiceEnabled();

    if (_locationEnabled) {
      // Get current location
      _currentPosition = await (widget.locationHelper ?? LocationHelper()).getCurrentPosition();

      _getWeatherDetailsWithCurrentLocation();
    } else if (_favoriteLocation != null) {
      _getWeatherDetailsWithFavoriteLocation();
    } else {
      setState(() {
        _body = const Center(
          key: Key('Weather details access'),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "You must enable location services and grant location permissions, or set a favorite location to view weather details.",
              textAlign: TextAlign
                  .center, // Optional: Center the text within the Padding
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _locationServiceStream.cancel();
  }

  void _readWeatherUnitsFromPreferences() {
    _weatherUnit = widget.preferences.getWeatherUnit();
    // Imperial return temp in Fahrenheit and wind speed in miles/h
    // while metric gives temp in Celsius and wind speed in m/s
    units = _weatherUnit ? "imperial" : "metric";
  }

  Future<void> readFavoriteLocationFromLocalDatabase() async {
    final location = await widget.databaseHelper.getLocalFavoriteLocation();
    setState(() {
      _favoriteLocation = location;
    });
  }

  Future<void> _getWeatherDetailsWithCurrentLocation() async {
    if (_currentPosition != null) {
      _getWeatherData(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude);
      _getForecastData(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude);
    }
  }

  Future<void> _getWeatherDetailsWithFavoriteLocation() async {
    if (_favoriteLocation != null) {
      _getWeatherData(
          latitude: _favoriteLocation!.latitude,
          longitude: _favoriteLocation!.longitude);
      _getForecastData(
          latitude: _favoriteLocation!.latitude,
          longitude: _favoriteLocation!.longitude);
    }
  }

  void _showExplanationDialogForLocationService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Service'),
          content: const Text(
              'Please enable location service to access the weather updated details.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getWeatherData(
      {required double latitude, required double longitude}) async {
    // Request weather data for current location
    weatherApiHelper
        .getCurrentWeatherData(latitude, longitude, units)
        .then((data) => setState(() {
              _weatherData = data;
              _updateUI();
            }));
  }

  Future<void> _getForecastData(
      {required double latitude, required double longitude}) async {
    // Request weather data for current location
    weatherApiHelper
        .getForecastData(latitude, longitude, units)
        .then((data) => setState(() {
              _forecastData = data;
              _updateUI();
            }));
  }

  void _updateUI() {
    if (_weatherData != null && _forecastData != null) {
      setState(() {
        _body = WeatherScreen(
            weatherData: _weatherData!, forecastData: _forecastData!);
      });
    }
  }

  void _settingIconPressed() {
    _closeDrawer();
    _navigateToSettingsScreen();
  }

  void _manageLocationTapped() {
    _closeDrawer();
    _navigateToManageLocationsScreen();
  }

  void _reportWrongLocation() {
    _closeDrawer();
    _navigateToReportWrongLocationScreen();
  }

  void _closeDrawer() {
    setState(() {
      Navigator.pop(context);
    });
  }

  void _navigateToSettingsScreen() async {
    final res = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingsScreen()));

    if (res == true) {
      readFavoriteLocationFromLocalDatabase(); // Fetch favorite location from local database
      _readWeatherUnitsFromPreferences(); // Read updated units
      _getWeatherDetailsWithCurrentLocation(); // Fetch weather data with modified units
      if (!widget.preferences.getAppAutoRefreshOnGoSetting()) {
        startWeatherDataFetch(); // Update timer with new values
      }
      // Add pull down to refresh to body if enable from settings
      if (widget.preferences.getAppAutoRefreshOnGoSetting()) {
        _buildBodyWithRefreshOrNot();
      }
    }
  }

  void _navigateToManageLocationsScreen() async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageLocationsScreen()),
    );

    if (res == true) {
      readFavoriteLocationFromLocalDatabase(); // Fetch favorite location from local database
      _readWeatherUnitsFromPreferences();
    }
  }

  void _navigateToReportWrongLocationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ReportWrongLocationScreen()),
    );
  }

  // Start the timer based on the user's selected interval
  Future<void> startWeatherDataFetch() async {
    int intervalInHours = widget.preferences.getAppAutoRefreshSetting();

    // Cancel the previous timer if it exists
    _timer?.cancel();

    // If the interval is "never" (0 hours), don't start any timer
    if (intervalInHours == 0) {
      if (kDebugMode) {
        print("Auto-fetch disabled");
      }
      return;
    }

    // Set up a periodic timer to fetch the weather data based on the interval
    _timer = Timer.periodic(Duration(hours: intervalInHours), (Timer t) async {
      await _getWeatherDetailsWithCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: WColors.blueGray500,
          iconTheme: const IconThemeData(color: Colors.white),
          title:
              _buildAppBarTitle(_locationEnabled, _weatherData?.name ?? "-")),
      body: _buildBodyWithRefreshOrNot(),
      drawer: SafeArea(child: _buildDrawerContainer(),),
    );
  }

  Widget _buildBodyWithRefreshOrNot() {
    // If the auto-refresh setting is enabled, use the RefreshIndicator.
    if (widget.preferences.getAppAutoRefreshOnGoSetting()) {
      return RefreshIndicator(
        onRefresh: _onPullRefresh,
        child: _body,
      );
    }
    // Otherwise, return the body directly.
    return _body;
  }

  Future<void> _onPullRefresh() async {
    if (await InternetHelper().isInternetAvailable()) {
      try {
        await _getWeatherDetailsWithCurrentLocation();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Weather data refreshed successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to refresh data')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection')),
        );
      }
    }
  }

  Widget _buildAppBarTitle(bool locationEnabled, String locationName) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            locationEnabled
                ? const Icon(Icons.location_on_outlined, color: Colors.white)
                : const Icon(Icons.location_off_outlined, color: Colors.white),
            const SizedBox(width: 15.0),
            Expanded(
                child: Text(
              locationName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ))
          ],
        ));
  }

  Widget _buildDrawerContainer() {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
        color: Colors.blueGrey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                tooltip: "Navigate to settings",
                onPressed: _settingIconPressed,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            _buildFavouriteLocationRowHeader(),
            const SizedBox(
              height: 10.0,
            ),
            _buildFavouriteLocationRowContent(),
            const SizedBox(
              height: 15.0,
            ),
            const DottedLine(
              dashLength: 2.0,
              dashColor: Colors.white,
            ),
            const SizedBox(
              height: 15.0,
            ),
            _buildOtherLocationsRowHeader(),
            const SizedBox(
              height: 15.0,
            ),
            _buildManageLocationRow(),
            const SizedBox(
              height: 15.0,
            ),
            const DottedLine(
              dashLength: 2.0,
              dashColor: Colors.white,
            ),
            const SizedBox(
              height: 15.0,
            ),
            _buildReportWrongLocationRow()
          ],
        ),
      ),
    );
  }

  Widget _buildFavouriteLocationRowHeader() {
    return Row(
      children: [
        const Icon(Icons.star_rate_rounded, size: 35.0, color: Colors.white),
        const SizedBox(
          width: 8.0,
        ),
        const Expanded(
            child: Text(
          "Favourite location",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
        )),
        Tooltip(
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          height: MediaQuery.of(context).size.width / 4,
          message: Strings.favouriteLocationDesc,
          textAlign: TextAlign.start,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(milliseconds: 3000),
          child: const Icon(
            Icons.info_outline_rounded,
            size: 24.0,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _buildFavouriteLocationRowContent() {
    if (_favoriteLocation == null) {
      return const Text("Set favorite location.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300));
    } else {
      final favoriteLocationTitle =
          "${_favoriteLocation?.name}, ${_favoriteLocation?.region}";
      final tempSymbol = _weatherUnit ? "ºF" : "ºC";

      return Row(
        children: [
          const SizedBox(
            width: 35.0,
          ),
          Icon(
              (_locationEnabled)
                  ? Icons.location_on_rounded
                  : Icons.location_off_rounded,
              color: Colors.white),
          const SizedBox(
            width: 3.0,
          ),
          Expanded(
              child: Text(
            favoriteLocationTitle.isNotEmpty
                ? favoriteLocationTitle
                : "Add Favorite location",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          )),
          const SizedBox(
            width: 5.0,
          ),
          Row(
            children: [
              // Icon(Icons.cloud, color: Colors.white),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                (_favoriteLocation != null)
                    ? "${_favoriteLocation?.currentTemperature.toStringAsFixed(0)}$tempSymbol"
                    : "",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400),
              )
            ],
          )
        ],
      );
    }
  }

  Widget _buildOtherLocationsRowHeader() {
    return const Row(
      children: [
        Icon(Icons.add_location_outlined, color: Colors.white70),
        SizedBox(
          width: 15.0,
        ),
        Expanded(
            child: Text(
          "Other locations",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
              fontWeight: FontWeight.w600),
        ))
      ],
    );
  }

  Widget _buildManageLocationRow() {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: _manageLocationTapped,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade100.withOpacity(0.2)),
              child: const Center(
                child: Text(
                  "Manage locations",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )));
  }

  Widget _buildReportWrongLocationRow() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: _reportWrongLocation,
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Transform.flip(
                  flipY: true,
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                const Expanded(
                  child: Text(
                    "Report wrong location",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
