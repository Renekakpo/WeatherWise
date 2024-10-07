import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  late SharedPreferences _prefs;

  static final AppSharedPreferences _instance = AppSharedPreferences._internal();

  factory AppSharedPreferences({SharedPreferences? prefs}) {
    if (prefs != null) {
      _instance._prefs = prefs;
    }

    return _instance;
  }

  AppSharedPreferences._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool getWeatherUnit() {
    return _prefs.getBool('weather_unit') ?? false;
  }

  Future<void> setWeatherUnit(bool value) async {
    await _prefs.setBool('weather_unit', value);
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