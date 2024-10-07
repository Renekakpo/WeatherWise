
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:weatherwise/helpers/permission_helper.dart';
import 'package:weatherwise/helpers/shared_preferences_helper.dart';
import 'package:weatherwise/main.dart';
import 'package:weatherwise/screens/home_screen.dart';

import 'splash_screen_test.mocks.dart';

@GenerateMocks([PermissionHelper, SharedPreferences, NavigatorObserver])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockPermissionHelper mockPermissionHelper;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockSharedPreferences mockSharedPreferences;
  late StreamController<PermissionStatus> permissionStatusController;

  setUpAll(() async {
    mockPermissionHelper = MockPermissionHelper();
    mockNavigatorObserver = MockNavigatorObserver();
    mockSharedPreferences = MockSharedPreferences();

    // Load the environment variables before running tests
    await dotenv.load(fileName: ".env");

    AppSharedPreferences(prefs: mockSharedPreferences);
    sqfliteFfiInit();
    // Change the default factory for unit testing calls for SQFlite
    databaseFactory = databaseFactoryFfi;

    when(mockNavigatorObserver.didPush(any, any)).thenReturn(null);
    when(mockNavigatorObserver.didPop(any, any)).thenReturn(null);
    when(mockNavigatorObserver.navigator).thenReturn(null);

    when(mockPermissionHelper.requestLocationPermission()).thenAnswer((_) async => true);
    when(mockPermissionHelper.shouldShowLocationRequestRationale()).thenAnswer((_) async => false);
    when(mockPermissionHelper.openSettings()).thenAnswer((_) async {});
    when(mockSharedPreferences.getBool('weather_unit')).thenReturn(true);
    when(mockSharedPreferences.getBool('auto_refresh_app_on_go')).thenReturn(true);
  });

  setUp(() {
    permissionStatusController = StreamController<PermissionStatus>();
    // Stub the permissionStatusStream method
    when(mockPermissionHelper.permissionStatusStream)
        .thenAnswer((_) => permissionStatusController.stream);
  });

  tearDown(() {
    permissionStatusController.close();
  });

  Future<void> pumpMyApp(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MyApp(permissionHelper: mockPermissionHelper,),
      navigatorObservers: [mockNavigatorObserver],
    ));
    await tester.pump(); // Let the first frame render
  }

  testWidgets('displays splash screen UI elements', (WidgetTester tester) async {

    when(mockPermissionHelper.isLocationPermissionGranted()).thenAnswer((_) async => true);

    await pumpMyApp(tester);

    // Verify the image and texts
    expect(find.byType(Image), findsOneWidget);
    expect(find.text("WeatherWise"), findsOneWidget);
    expect(find.text("Don't worry about the weather we all here."), findsOneWidget);
  });

  testWidgets('navigates to HomeScreen when permission is granted', (WidgetTester tester) async {
    when(mockPermissionHelper.isLocationPermissionGranted()).thenAnswer((_) async => true);

    await pumpMyApp(tester);

    if (!permissionStatusController.isClosed) {
      permissionStatusController.add(PermissionStatus.granted);
    }

    await tester.pump();

    verify(mockNavigatorObserver.didPush(any, any)); // Check that a navigation occurred
    expect(find.byType(HomeScreen), findsOneWidget); // Verify HomeScreen is pushed
  });

  testWidgets('shows explanation dialog when permission is denied', (WidgetTester tester) async {
    // Arrange
    when(mockPermissionHelper.isLocationPermissionGranted()).thenAnswer((_) async => false);
    when(mockPermissionHelper.shouldShowLocationRequestRationale()).thenAnswer((_) async => true);

    await pumpMyApp(tester);

    // Act
    if (!permissionStatusController.isClosed) {
      permissionStatusController.add(PermissionStatus.denied);
    }

    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Location Permission Required'), findsOneWidget);
  });

  testWidgets('opens app settings when permission is denied forever', (WidgetTester tester) async {
    // Arrange
    when(mockPermissionHelper.isLocationPermissionGranted()).thenAnswer((_) async => false);
    when(mockPermissionHelper.shouldShowLocationRequestRationale()).thenAnswer((_) async => false);

    await pumpMyApp(tester);

    // Act
    if (!permissionStatusController.isClosed) {
      permissionStatusController.add(PermissionStatus.deniedForever);
    }

    // Act
    await tester.pumpAndSettle();

    // Assert
    verify(mockPermissionHelper.openSettings()).called(1); // App settings should open
  });

}