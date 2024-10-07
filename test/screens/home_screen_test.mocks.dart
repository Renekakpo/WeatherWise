// Mocks generated by Mockito 5.4.4 from annotations
// in weatherwise/test/screens/home_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:flutter/src/widgets/navigator.dart' as _i13;
import 'package:geolocator/geolocator.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i10;
import 'package:shared_preferences/shared_preferences.dart' as _i4;
import 'package:sqflite/sqflite.dart' as _i2;
import 'package:weatherwise/helpers/database_helper.dart' as _i7;
import 'package:weatherwise/helpers/location_helper.dart' as _i14;
import 'package:weatherwise/helpers/shared_preferences_helper.dart' as _i6;
import 'package:weatherwise/models/forecast_data.dart' as _i12;
import 'package:weatherwise/models/manage_location.dart' as _i8;
import 'package:weatherwise/models/weather_data.dart' as _i11;
import 'package:weatherwise/network/weather_api_helper.dart' as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDatabase_0 extends _i1.SmartFake implements _i2.Database {
  _FakeDatabase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePosition_1 extends _i1.SmartFake implements _i3.Position {
  _FakePosition_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SharedPreferences].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferences extends _i1.Mock implements _i4.SharedPreferences {
  MockSharedPreferences() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Set<String> getKeys() => (super.noSuchMethod(
        Invocation.method(
          #getKeys,
          [],
        ),
        returnValue: <String>{},
      ) as Set<String>);

  @override
  Object? get(String? key) => (super.noSuchMethod(Invocation.method(
        #get,
        [key],
      )) as Object?);

  @override
  bool? getBool(String? key) => (super.noSuchMethod(Invocation.method(
        #getBool,
        [key],
      )) as bool?);

  @override
  int? getInt(String? key) => (super.noSuchMethod(Invocation.method(
        #getInt,
        [key],
      )) as int?);

  @override
  double? getDouble(String? key) => (super.noSuchMethod(Invocation.method(
        #getDouble,
        [key],
      )) as double?);

  @override
  String? getString(String? key) => (super.noSuchMethod(Invocation.method(
        #getString,
        [key],
      )) as String?);

  @override
  bool containsKey(String? key) => (super.noSuchMethod(
        Invocation.method(
          #containsKey,
          [key],
        ),
        returnValue: false,
      ) as bool);

  @override
  List<String>? getStringList(String? key) =>
      (super.noSuchMethod(Invocation.method(
        #getStringList,
        [key],
      )) as List<String>?);

  @override
  _i5.Future<bool> setBool(
    String? key,
    bool? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setBool,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setInt(
    String? key,
    int? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setInt,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setDouble(
    String? key,
    double? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setDouble,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setString(
    String? key,
    String? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setString,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> setStringList(
    String? key,
    List<String>? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setStringList,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> remove(String? key) => (super.noSuchMethod(
        Invocation.method(
          #remove,
          [key],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> commit() => (super.noSuchMethod(
        Invocation.method(
          #commit,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> clear() => (super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<void> reload() => (super.noSuchMethod(
        Invocation.method(
          #reload,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [AppSharedPreferences].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppSharedPreferences extends _i1.Mock
    implements _i6.AppSharedPreferences {
  MockAppSharedPreferences() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  bool getWeatherUnit() => (super.noSuchMethod(
        Invocation.method(
          #getWeatherUnit,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<void> setWeatherUnit(bool? value) => (super.noSuchMethod(
        Invocation.method(
          #setWeatherUnit,
          [value],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  int getAppAutoRefreshSetting() => (super.noSuchMethod(
        Invocation.method(
          #getAppAutoRefreshSetting,
          [],
        ),
        returnValue: 0,
      ) as int);

  @override
  void setAppAutoRefreshSetting(int? value) => super.noSuchMethod(
        Invocation.method(
          #setAppAutoRefreshSetting,
          [value],
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool getAppAutoRefreshOnGoSetting() => (super.noSuchMethod(
        Invocation.method(
          #getAppAutoRefreshOnGoSetting,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  void setAppAutoRefreshOnGoSetting(bool? value) => super.noSuchMethod(
        Invocation.method(
          #setAppAutoRefreshOnGoSetting,
          [value],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [DatabaseHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseHelper extends _i1.Mock implements _i7.DatabaseHelper {
  MockDatabaseHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Database> get database => (super.noSuchMethod(
        Invocation.getter(#database),
        returnValue: _i5.Future<_i2.Database>.value(_FakeDatabase_0(
          this,
          Invocation.getter(#database),
        )),
      ) as _i5.Future<_i2.Database>);

  @override
  _i5.Future<void> insertLocation(_i8.ManageLocation? location) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertLocation,
          [location],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<List<_i8.ManageLocation>> getAllLocations() => (super.noSuchMethod(
        Invocation.method(
          #getAllLocations,
          [],
        ),
        returnValue:
            _i5.Future<List<_i8.ManageLocation>>.value(<_i8.ManageLocation>[]),
      ) as _i5.Future<List<_i8.ManageLocation>>);

  @override
  _i5.Future<void> deleteAllLocations() => (super.noSuchMethod(
        Invocation.method(
          #deleteAllLocations,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteLocation(int? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteLocation,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setFavoriteLocation(int? id) => (super.noSuchMethod(
        Invocation.method(
          #setFavoriteLocation,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i8.ManageLocation?> getLocalFavoriteLocation() =>
      (super.noSuchMethod(
        Invocation.method(
          #getLocalFavoriteLocation,
          [],
        ),
        returnValue: _i5.Future<_i8.ManageLocation?>.value(),
      ) as _i5.Future<_i8.ManageLocation?>);
}

/// A class which mocks [WeatherApiHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockWeatherApiHelper extends _i1.Mock implements _i9.WeatherApiHelper {
  MockWeatherApiHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get apiKey => (super.noSuchMethod(
        Invocation.getter(#apiKey),
        returnValue: _i10.dummyValue<String>(
          this,
          Invocation.getter(#apiKey),
        ),
      ) as String);

  @override
  String get baseUrl => (super.noSuchMethod(
        Invocation.getter(#baseUrl),
        returnValue: _i10.dummyValue<String>(
          this,
          Invocation.getter(#baseUrl),
        ),
      ) as String);

  @override
  _i5.Future<_i11.WeatherData?> getCurrentWeatherData(
    double? latitude,
    double? longitude,
    String? units,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCurrentWeatherData,
          [
            latitude,
            longitude,
            units,
          ],
        ),
        returnValue: _i5.Future<_i11.WeatherData?>.value(),
      ) as _i5.Future<_i11.WeatherData?>);

  @override
  _i5.Future<_i12.ForecastData?> getForecastData(
    double? latitude,
    double? longitude,
    String? units,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getForecastData,
          [
            latitude,
            longitude,
            units,
          ],
        ),
        returnValue: _i5.Future<_i12.ForecastData?>.value(),
      ) as _i5.Future<_i12.ForecastData?>);
}

/// A class which mocks [NavigatorObserver].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigatorObserver extends _i1.Mock implements _i13.NavigatorObserver {
  MockNavigatorObserver() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void didPush(
    _i13.Route<dynamic>? route,
    _i13.Route<dynamic>? previousRoute,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #didPush,
          [
            route,
            previousRoute,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void didPop(
    _i13.Route<dynamic>? route,
    _i13.Route<dynamic>? previousRoute,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #didPop,
          [
            route,
            previousRoute,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void didRemove(
    _i13.Route<dynamic>? route,
    _i13.Route<dynamic>? previousRoute,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #didRemove,
          [
            route,
            previousRoute,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void didReplace({
    _i13.Route<dynamic>? newRoute,
    _i13.Route<dynamic>? oldRoute,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #didReplace,
          [],
          {
            #newRoute: newRoute,
            #oldRoute: oldRoute,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void didStartUserGesture(
    _i13.Route<dynamic>? route,
    _i13.Route<dynamic>? previousRoute,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #didStartUserGesture,
          [
            route,
            previousRoute,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void didStopUserGesture() => super.noSuchMethod(
        Invocation.method(
          #didStopUserGesture,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [LocationHelper].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocationHelper extends _i1.Mock implements _i14.LocationHelper {
  MockLocationHelper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<bool> isLocationServiceEnabled() => (super.noSuchMethod(
        Invocation.method(
          #isLocationServiceEnabled,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<_i3.Position> getCurrentPosition() => (super.noSuchMethod(
        Invocation.method(
          #getCurrentPosition,
          [],
        ),
        returnValue: _i5.Future<_i3.Position>.value(_FakePosition_1(
          this,
          Invocation.method(
            #getCurrentPosition,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Position>);
}
