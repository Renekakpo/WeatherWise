import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weatherwise/screens/manage_locations_screen.dart';
import 'package:weatherwise/screens/report_wrong_location.dart';
import 'package:weatherwise/screens/settings_screen.dart';
import 'package:weatherwise/screens/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30, fontFamily: "Roboto", fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];
  final String favouriteLocationDesc =
      "Your favourite location will be used to provide weather information in notifications and other connected services. You can change your favorite location in your location list.";

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

  void _navigateToSettingsScreen() {
    Future.delayed(Durations.short1, () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()));
    });
  }

  void _navigateToManageLocationsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageLocationsScreen()),
    );
  }

  void _navigateToReportWrongLocationScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ReportWrongLocationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFF8FAFD),
          iconTheme: const IconThemeData(color: Colors.black54),
          title: _buildAppBarTitle()),
      body: const WeatherScreen(),
      drawer: _buildDrawerContainer(),
    );
  }

  Widget _buildAppBarTitle() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.black),
            const SizedBox(width: 15.0),
            Expanded(
                child: Text(
              widget.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w600),
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
              height: 20.0,
            ),
            // List of other locations
            _buildOtherLocationsRowContent(),
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
          message: favouriteLocationDesc,
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
    return const Row(
      children: [
        SizedBox(
          width: 35.0,
        ),
        Icon(Icons.location_off_rounded, color: Colors.white),
        SizedBox(
          width: 3.0,
        ),
        Expanded(
            child: Text(
          "Location name goes here",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        )),
        SizedBox(
          width: 5.0,
        ),
        Row(
          children: [
            Icon(Icons.cloud, color: Colors.white),
            SizedBox(
              width: 5.0,
            ),
            Text(
              "32º",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            )
          ],
        )
      ],
    );
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

  Widget _buildOtherLocationsRowContent() {
    return const Row(
      children: [
        SizedBox(
          width: 40.0,
        ),
        Expanded(
            child: Text(
          "Location name...",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w400),
        )),
        SizedBox(
          width: 10.0,
        ),
        Row(
          children: [
            Icon(Icons.cloud, color: Colors.white),
            SizedBox(
              width: 5.0,
            ),
            Text("35º",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400))
          ],
        )
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
