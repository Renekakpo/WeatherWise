import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherwise/core/result/result.dart';
import 'package:weatherwise/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:weatherwise/features/settings/domain/entities/app_settings.dart';
import 'package:weatherwise/features/settings/domain/entities/temperature_unit.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late _MockSharedPreferences prefs;
  late SettingsRepositoryImpl repository;

  setUp(() {
    prefs = _MockSharedPreferences();
    repository = SettingsRepositoryImpl(prefs);
  });

  group('SettingsRepositoryImpl.load', () {
    test('returns defaults when no value is stored', () async {
      when(() => prefs.getBool('weather_unit')).thenReturn(null);
      when(() => prefs.getInt('auto_refresh_app')).thenReturn(null);
      when(() => prefs.getBool('auto_refresh_app_on_go')).thenReturn(null);

      final result = await repository.load();

      expect(result, isA<Success<AppSettings>>());
      final settings = (result as Success<AppSettings>).data;
      expect(settings.unit, TemperatureUnit.metric);
      expect(settings.autoRefreshHours, 0);
      expect(settings.refreshOnTheGo, isFalse);
    });

    test('reads stored values correctly', () async {
      when(() => prefs.getBool('weather_unit')).thenReturn(true);
      when(() => prefs.getInt('auto_refresh_app')).thenReturn(3);
      when(() => prefs.getBool('auto_refresh_app_on_go')).thenReturn(true);

      final result = await repository.load();

      expect(result.dataOrNull?.unit, TemperatureUnit.imperial);
      expect(result.dataOrNull?.autoRefreshHours, 3);
      expect(result.dataOrNull?.refreshOnTheGo, isTrue);
    });
  });

  group('SettingsRepositoryImpl.save', () {
    test('writes all three prefs and returns Success', () async {
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => prefs.setInt(any(), any())).thenAnswer((_) async => true);

      const settings = AppSettings(
        unit: TemperatureUnit.imperial,
        autoRefreshHours: 12,
        refreshOnTheGo: true,
      );

      final result = await repository.save(settings);

      expect(result.isSuccess, isTrue);
      verify(() => prefs.setBool('weather_unit', true)).called(1);
      verify(() => prefs.setInt('auto_refresh_app', 12)).called(1);
      verify(() => prefs.setBool('auto_refresh_app_on_go', true)).called(1);
    });

    test('returns CacheFailure when persistence throws', () async {
      when(() => prefs.setBool(any(), any())).thenThrow(Exception('disk full'));

      final result = await repository.save(const AppSettings.defaults());

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.message, 'Local storage error');
    });
  });
}
