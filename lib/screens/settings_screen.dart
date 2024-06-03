import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weatherwise/helpers/shared_preferences_helper.dart';
import 'package:weatherwise/utils/strings.dart';
import 'package:weatherwise/widgets/custom_radio_button.dart';
import 'package:weatherwise/widgets/custom_switch_with_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _weatherUnit = false; // Default value
  bool _windUnit = false; // Default value
  bool _refreshOnTheGo = false;
  int _autoRefreshSelectedOption = 0; // Default value

  @override
  void initState() {
    super.initState();
    // Update views when widget initializes
    _loadUnitsOptions();
    _loadAutoRefreshSelectedOption();
    _loadAutoRefreshOnTheGoValue();
  }

  void _onBackArrowPressed() {
    Navigator.pop(context);
  }

  Future<void> _loadUnitsOptions() async {
    setState(() {
      _weatherUnit = AppSharedPreferences().getWeatherUnit();
      _windUnit = AppSharedPreferences().getWindUnit();
    });
  }

  Future<void> _loadAutoRefreshSelectedOption() async {
    setState(() {
      _autoRefreshSelectedOption = AppSharedPreferences()
          .getAppAutoRefreshSetting(); // Default to 0 if not set
    });
  }

  Future<void> _saveAutoRefreshSelectedOption(int value) async {
    AppSharedPreferences()
        .setAppAutoRefreshSetting(value); // Save the selected option to pref
    Navigator.pop(context); // Close the bottom sheet
  }

  Future<void> _loadAutoRefreshOnTheGoValue() async {
    setState(() {
      _refreshOnTheGo = AppSharedPreferences().getAppAutoRefreshOnGoSetting();
    });
  }

  void _onWeatherUnitChanged(bool updatedValue) async {
    setState(() {
      _weatherUnit = updatedValue;
      AppSharedPreferences()
          .setWeatherUnit(updatedValue); // false: Celsius, true: Fahrenheit
    });
  }

  void _onWindUnitChanged(bool updatedValue) async {
    setState(() {
      _windUnit = updatedValue;
      AppSharedPreferences()
          .setWindUnit(updatedValue); // false: Miles, true: Kilometer
    });
  }

  void _onShowAutoRefreshOptionsSheet() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text(Strings.appAutoRefreshLabel,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500)),
                CustomRadioButton(
                  title: Strings.neverLabel,
                  value: 0,
                  groupValue: _autoRefreshSelectedOption,
                  onChanged: (value) {
                    setState(() {
                      _autoRefreshSelectedOption = value!;
                      _saveAutoRefreshSelectedOption(value);
                    });
                  },
                ),
                CustomRadioButton(
                    title: Strings.everyHourLabel,
                    value: 1,
                    groupValue: _autoRefreshSelectedOption,
                    onChanged: (value) {
                      setState(() {
                        _autoRefreshSelectedOption = value!;
                        _saveAutoRefreshSelectedOption(value);
                      });
                    }),
                CustomRadioButton(
                    title: Strings.everyThreeHourLabel,
                    value: 3,
                    groupValue: _autoRefreshSelectedOption,
                    onChanged: (value) {
                      setState(() {
                        _autoRefreshSelectedOption = value!;
                        _saveAutoRefreshSelectedOption(value);
                      });
                    }),
                CustomRadioButton(
                    title: Strings.everySixHourLabel,
                    value: 6,
                    groupValue: _autoRefreshSelectedOption,
                    onChanged: (value) {
                      setState(() {
                        _autoRefreshSelectedOption = value!;
                        _saveAutoRefreshSelectedOption(value);
                      });
                    }),
                CustomRadioButton(
                    title: Strings.everyTwelveHourLabel,
                    value: 12,
                    groupValue: _autoRefreshSelectedOption,
                    onChanged: (value) {
                      setState(() {
                        _autoRefreshSelectedOption = value!;
                        _saveAutoRefreshSelectedOption(value);
                      });
                    }),
                CustomRadioButton(
                    title: Strings.everyTwentyFourHourLabel,
                    value: 24,
                    groupValue: _autoRefreshSelectedOption,
                    onChanged: (value) {
                      setState(() {
                        _autoRefreshSelectedOption = value!;
                        _saveAutoRefreshSelectedOption(value);
                      });
                    })
              ],
            ),
          );
        });
  }

  void _onRefreshOnTheGo(bool value) async {
    setState(() {
      _refreshOnTheGo = value;
      AppSharedPreferences().setAppAutoRefreshOnGoSetting(value);
    });
  }

  void _onNotificationsTapped() {
    if (Platform.isAndroid) {
      const AndroidIntent intent = AndroidIntent(
        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        arguments: <String, dynamic>{
          'android.provider.extra.APP_PACKAGE': 'com.example.weatherwise'
        },
      );
      intent.launch();
    } else if (Platform.isIOS) {
      FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.pendingNotificationRequests();
      // Open iOS app settings
    }
  }

  void _onShareTapped() {
    print("Shared tapped!");
  }

  void _onOpenLicencesTapped() {
    print("Open app info");
  }

  void _onOpenAppDetails() {
    try {} catch (e) {
      print("Error: $e");
    }
    print("Open app details settings");
  }

  void _onAboutTapped() {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: _onOpenAppDetails,
                      icon: const Icon(Icons.info_outline_rounded)),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text("WeatherWise",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 5.0),
                const Text("Version 1.0.0",
                    style: TextStyle(fontFamily: 'Roboto')),
                const Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: _onOpenLicencesTapped,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade300.withOpacity(0.5)),
                            child: const Center(
                              child: Expanded(
                                  child: Text(
                                "Open source licences",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ))),
                ),
              ],
            ),
          );
        });
  }

  void _onReviewTapped() {
    print("Review tapped!");
  }

  void _onFeedbackTapped() {
    print("Feedback tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: _onBackArrowPressed,
        ),
        title: const Text(Strings.weatherSettingsTitle,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20.0,
                fontWeight: FontWeight.w700)),
      ), // AppBar
      body: Container(
        // Body
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        color: const Color(0xFFF8FAFD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              Strings.unitsLabel,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    )
                  ]),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // Weather Unit
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(Strings.weatherUnitLabel,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500)),
                      CustomSwitchWithText(
                        activeText: Strings.weatherUnitFahrenheitLabel,
                        inactiveText: Strings.weatherUnitCelsiusLabel,
                        unitValue: _weatherUnit,
                        onUnitChanged: _onWeatherUnitChanged,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    // Wind Unit
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(Strings.windUnitLabel,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500)),
                      CustomSwitchWithText(
                        activeText: Strings.windUnitKiloLabel,
                        inactiveText: Strings.windUnitMileLabel,
                        unitValue: _windUnit,
                        onUnitChanged: _onWindUnitChanged,
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Text(
              Strings.appLabel,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2.0,
                      blurRadius: 10.0,
                      offset: const Offset(0, 3), // changes position of shadow
                    )
                  ]),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    // Auto refresh
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: _onShowAutoRefreshOptionsSheet,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5.0),
                            child: const Row(
                              children: [
                                Icon(
                                  CupertinoIcons.refresh_circled,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: Text(
                                    Strings.appAutoRefreshLabel,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'Roboto', fontSize: 17.0),
                                  ),
                                )
                              ],
                            ))),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                      // Auto refresh on the go
                      width: double.infinity,
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.refresh_circled,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          const Expanded(
                              child: Text(
                            Strings.appAutoRefreshOnTheGoLabel,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17.0),
                          )),
                          Switch(
                              activeColor: Colors.blue,
                              value: _refreshOnTheGo,
                              onChanged: _onRefreshOnTheGo)
                        ],
                      )),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Material(
                    // Notification
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: _onNotificationsTapped,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5.0),
                            child: const Row(children: [
                              Icon(
                                Icons.notifications_outlined,
                                size: 20.0,
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                Strings.appNotificationsLabel,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 17.0),
                              )
                            ]))),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Material(
                    // Share
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: _onShareTapped,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5.0),
                            child: const Row(
                              children: [
                                Icon(
                                  CupertinoIcons.share,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  Strings.appShareLabel,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 17.0),
                                )
                              ],
                            ))),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Material(
                    // About
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: _onAboutTapped,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5.0),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  Strings.appAboutLabel,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 17.0),
                                )
                              ],
                            ))),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    )
                  ]),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    // Review
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: _onReviewTapped,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          child: const Text(
                            "Review",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Material(
                      // Feedback
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: _onFeedbackTapped,
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: const Text(
                                "Feedback",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 17.0),
                              ))))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
