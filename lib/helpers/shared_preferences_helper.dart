import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  late SharedPreferences _prefs;

  static final AppSharedPreferences _instance = AppSharedPreferences._internal();

  factory AppSharedPreferences() {
    return _instance;
  }

  AppSharedPreferences._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int getCounter() {
    return _prefs.getInt('counter') ?? 0;
  }

  void incrementCounter() {
    int counter = getCounter();
    counter++;
    _prefs.setInt('counter', counter);
  }

  int getWeatherUnit() {
    return _prefs.getInt('weather_unit') ?? 0;
  }

  void setWeatherUnit(int value) {
    _prefs.setInt('weather_unit', value);
  }

  int getWindUnit() {
    return _prefs.getInt('wind_unit') ?? 0;
  }

  void setWindUnit(int value) {
    _prefs.setInt('wind_unit', value);
  }

  int getAppAutoRefreshSetting() {
    return _prefs.getInt('auto_refresh_app') ?? 0;
  }

  void setAppAutoRefreshSetting(int value) {
    _prefs.setInt('auto_refresh_app', value);
  }

  bool getAppAutoRefreshOnGoSetting() {
    return _prefs.getBool('auto_refresh_app_on_go') ?? false;
  }

  void setAppAutoRefreshOnGoSetting(bool value) {
    _prefs.setBool('auto_refresh_app_on_go', value);
  }
}