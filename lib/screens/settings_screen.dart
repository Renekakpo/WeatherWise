import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  bool _weatherUnit = false;
  bool _windUnit = false;
  bool refreshOnTheGo = false;
  int _selectedOption = 1;
  int neverOption = 1;
  int everyHourOpt = 0;
  int everyThreeHourOpt = 0;
  int everySixHourOpt = 0;
  int everyTwelveHourOpt = 0;
  int everyTwentyFourHourOpt = 0;

  void _onBackArrowPressed() {
    Navigator.pop(context);
  }

  void _onWeatherUnitChanged(bool updatedValue) {
    setState(() {
      _weatherUnit = updatedValue;
      AppSharedPreferences().setWeatherUnit(updatedValue ? 1 : 0);
    });
  }

  void _onWindUnitChanged(bool updatedValue) {
    setState(() {
      _windUnit = updatedValue;
      AppSharedPreferences().setWeatherUnit(updatedValue ? 1 : 0);
    });
  }

  void _onAutoRefreshUpdated(int updatedValue) {
    setState(() {
      AppSharedPreferences().setAppAutoRefreshSetting(updatedValue);
    });
  }

  void _editAutoRefreshOptions() {
    int currentAutoRefreshOpt = AppSharedPreferences().getAppAutoRefreshSetting();
    // Define a map to represent the options and their values
    final optionsMap = {
      0: [1, 0, 0, 0, 0, 0],
      1: [0, 1, 0, 0, 0, 0],
      3: [0, 0, 1, 0, 0, 0],
      6: [0, 0, 0, 1, 0, 0],
      12: [0, 0, 0, 0, 1, 0],
      24: [0, 0, 0, 0, 0, 1],
    };

    // Update options based on the currentAutoRefreshOpt
    if (optionsMap.containsKey(currentAutoRefreshOpt)) {
      final values = optionsMap[currentAutoRefreshOpt];
      neverOption = values?[0] ?? 0;
      everyHourOpt = values?[1] ?? 0;
      everyThreeHourOpt = values?[2] ?? 0;
      everySixHourOpt = values?[3] ?? 0;
      everyTwelveHourOpt = values?[4] ?? 0;
      everyTwentyFourHourOpt = values?[5] ?? 0;
    } else {
      if (kDebugMode) {
        print("Unknown option");
      }
    }
  }

  void _onAutoRefreshTapped() {
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
                  value: neverOption,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    _onAutoRefreshUpdated(0);
                  },
                ),
                CustomRadioButton(
                    title: Strings.everyHourLabel,
                    value: everyHourOpt,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      _onAutoRefreshUpdated(1);
                    }),
                CustomRadioButton(
                    title: Strings.everyThreeHourLabel,
                    value: everyThreeHourOpt,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      _onAutoRefreshUpdated(3);
                    }),
                CustomRadioButton(
                    title: Strings.everySixHourLabel,
                    value: everySixHourOpt,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      _onAutoRefreshUpdated(6);
                    }),
                CustomRadioButton(
                    title: Strings.everyTwelveHourLabel,
                    value: 12,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      _onAutoRefreshUpdated(12);
                    }),
                CustomRadioButton(
                    title: Strings.everyTwentyFourHourLabel,
                    value: everyTwentyFourHourOpt,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      _onAutoRefreshUpdated(24);
                    })
              ],
            ),
          );
        });
  }

  void _onRefreshOnTheGo(bool value) {
    setState(() {
      refreshOnTheGo = value;
    });
  }

  void _onNotificationsTapped() {
    print("Notifications tapped!");
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
  void initState() {
    super.initState();
    // Update views when widget initializes
    _weatherUnit = AppSharedPreferences().getWeatherUnit() == 1 ? true : false;
    _windUnit = AppSharedPreferences().getWeatherUnit() == 1 ? true : false;
    refreshOnTheGo = AppSharedPreferences().getAppAutoRefreshOnGoSetting();
    _editAutoRefreshOptions();
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
      ),
      body: Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(Strings.weatherUnitLabel,
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 17.0,
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
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: _onAutoRefreshTapped,
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
                              value: refreshOnTheGo,
                              onChanged: _onRefreshOnTheGo)
                        ],
                      )),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Material(
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
