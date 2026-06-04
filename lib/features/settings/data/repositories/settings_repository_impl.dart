import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../core/storage/prefs/prefs_keys.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/temperature_unit.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<Result<AppSettings>> load() async {
    try {
      final isImperial = _prefs.getBool(PrefsKeys.weatherUnit) ?? false;
      final hours = _prefs.getInt(PrefsKeys.autoRefreshHours) ?? 0;
      final refreshOnTheGo = _prefs.getBool(PrefsKeys.refreshOnTheGo) ?? false;
      return Success(
        AppSettings(
          unit: TemperatureUnit.fromIsImperial(isImperial),
          autoRefreshHours: hours,
          refreshOnTheGo: refreshOnTheGo,
        ),
      );
    } catch (e) {
      return Failure(mapExceptionToFailure(e) is CacheFailure
          ? mapExceptionToFailure(e)
          : CacheFailure(cause: e));
    }
  }

  @override
  Future<Result<void>> save(AppSettings settings) async {
    try {
      await _prefs.setBool(PrefsKeys.weatherUnit, settings.unit.isImperial);
      await _prefs.setInt(PrefsKeys.autoRefreshHours, settings.autoRefreshHours);
      await _prefs.setBool(PrefsKeys.refreshOnTheGo, settings.refreshOnTheGo);
      return const Success(null);
    } catch (e) {
      return Failure(CacheFailure(cause: e));
    }
  }
}
