import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherwise/helpers/shared_preferences_helper.dart';
import 'package:weatherwise/screens/settings_screen.dart';
import 'package:weatherwise/utils/strings.dart';
import 'package:weatherwise/widgets/custom_radio_button.dart';
import 'package:weatherwise/widgets/custom_switch_with_text.dart';

import 'home_screen_test.mocks.dart';

@GenerateMocks([NavigatorObserver, SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockNavigatorObserver mockNavigatorObserver;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    mockNavigatorObserver = MockNavigatorObserver();
    mockSharedPreferences = MockSharedPreferences();

    AppSharedPreferences(prefs: mockSharedPreferences);

    when(mockNavigatorObserver.didPush(any, any)).thenReturn(null);
    when(mockNavigatorObserver.didPop(any, any)).thenReturn(null);
    when(mockNavigatorObserver.navigator).thenReturn(null);

    // Stub some of the app's shared preferences method
    when(mockSharedPreferences.setBool('weather_unit', true)).thenAnswer((_) async => true);
    when(mockSharedPreferences.setBool('auto_refresh_app_on_go', true)).thenAnswer((_) async => true);
    when(mockSharedPreferences.getBool('weather_unit')).thenReturn(false); // False: Celsius
    when(mockSharedPreferences.getInt('auto_refresh_app')).thenReturn(0);
    when(mockSharedPreferences.getBool('auto_refresh_app_on_go')).thenReturn(false);
  });

  group('SettingsScreen Tests', () {
    testWidgets('Weather unit switch should change state', (WidgetTester tester) async {
      // Build SettingsScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      // Verify initial weather unit is Celsius (false)
      expect(find.byType(CustomSwitchWithText), findsOneWidget);
      expect(find.byKey(const Key('weather_units_label')), findsOneWidget);

      // Tap the switch to change to Fahrenheit
      await tester.tap(find.byType(CustomSwitchWithText));
      await tester.pumpAndSettle();

      // Verify the weather unit has changed to Fahrenheit
      final updatedSwitch = tester.widget<CustomSwitchWithText>(find.byType(CustomSwitchWithText));
      expect(updatedSwitch.unitValue, true); // True: Fahrenheit
    });

    testWidgets('Auto-refresh options bottom sheet displays and options can be selected', (WidgetTester tester) async {
      // Build SettingsScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      // Tap on the auto-refresh row to open the modal bottom sheet
      await tester.tap(find.byKey(const Key('auto_refresh_item')));
      await tester.pumpAndSettle();

      // Verify bottom sheet is displayed with refresh options
      expect(find.byType(CustomRadioButton), findsNWidgets(6));

      // Select the "Every Three Hours" option
      await tester.tap(find.text(Strings.everyThreeHourLabel));
      await tester.pumpAndSettle();
    });

    testWidgets('Auto-refresh on the go switch should change state', (WidgetTester tester) async {
      // Build SettingsScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      // Tap on the auto-refresh row to open the modal bottom sheet
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Verify auto-refresh on the go state has changed
      final updatedSwitch = tester.widget<Switch>(find.byType(Switch));
      expect(updatedSwitch.value, true); // True: Fahrenheit
    });

    testWidgets('Navigates back when back arrow is pressed', (WidgetTester tester) async {
      // Create a mock NavigatorObserver to track navigation actions
      // final mockObserver = MockNavigatorObserver();

      // Build SettingsScreen widget with observer
      await tester.pumpWidget(MaterialApp(
        home: const SettingsScreen(),
        navigatorObservers: [mockNavigatorObserver],
      ));

      // Tap on the back button
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify that the back navigation was triggered
      verify(mockNavigatorObserver.didPop(any, any)).called(1);
    });

    testWidgets('Notification settings tapped on Android', (WidgetTester tester) async {
      // Build SettingsScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      // Mock that the platform is Android
      // Tap on the notification settings option
      await tester.tap(find.text('Notifications'));
      await tester.pumpAndSettle();

      // Verify that the Android intent is triggered (mock the intent)
      // Not directly testable, but can mock behavior.
    });

    testWidgets('About bottom sheet opens and displays info', (WidgetTester tester) async {
      // Build SettingsScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: SettingsScreen(),
      ));

      // Tap on the "About" option to open bottom sheet
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      // Verify the about modal bottom sheet is displayed with app name and version
      expect(find.text('WeatherWise'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);
    });
  });

}