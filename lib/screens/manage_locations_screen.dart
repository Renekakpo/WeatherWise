import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../helpers/DatabaseHelper.dart';
import '../helpers/LocationHelper.dart';
import '../helpers/utils_helper.dart';
import '../models/manage_location.dart';
import 'add_location_screen.dart';

class ManageLocationsScreen extends StatefulWidget {
  const ManageLocationsScreen({super.key});

  @override
  State<ManageLocationsScreen> createState() => _ManageLocationsScreenState();
}

class _ManageLocationsScreenState extends State<ManageLocationsScreen> {
  final dbHelper = DatabaseHelper();
  bool isEditing = false;
  bool _isDeviceLocationOn = false;
  List<ManageLocation> selectedLocations = [];
  List<ManageLocation> locations = [];

  @override
  void initState() {
    super.initState();
    _checkDeviceLocationStatus(); // Check if device location is on or off
    _loadLocations(); // Load locations when the widget is first built
  }

  Future<void> _checkDeviceLocationStatus() async {
    final status = await LocationHelper().isLocationServiceEnabled();
    setState(() {
      _isDeviceLocationOn = status;
    });
  }

  Future<void> _loadLocations() async {
    final allLocations = await dbHelper.getAllLocations();
    setState(() {
      locations = allLocations.reversed.toList();
    });
  }

  void _onBackArrowPressed() {
    Navigator.pop(context);
  }

  void _toggleEditing() {
    if (locations.isNotEmpty) {
      setState(() {
        isEditing = !isEditing;
        selectedLocations.clear();
      });
    }
  }

  void _onItemTap(ManageLocation location) {
    setState(() {
      if (selectedLocations.contains(location)) {
        selectedLocations.remove(location);
      } else {
        selectedLocations.add(location);
      }
    });
  }

  void _onSetFavouritePressed() {
    setState(() {
      var favouriteLocation = selectedLocations.first;
      // Update the favourite location in database
      if (favouriteLocation.id != null) {
        dbHelper.setFavoriteLocation(favouriteLocation.id!);
      }
      // Update the local list
      for (var location in locations) {
        location.isFavorite = location == favouriteLocation ? true : false;
      }
      selectedLocations.first.isFavorite = true;
    });
  }

  void _onDeletePressed() {
    setState(() {
      try {
        // Delete the location from database
        if (selectedLocations.first.id != null) {
          dbHelper.deleteLocation(selectedLocations.first.id!);
        }
        // Remove selected location from the main list
        locations.removeWhere((element) => selectedLocations.contains(element));
        // Clear selected locations list
        selectedLocations.clear();
        // Disable the edit mode
        isEditing = false;
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  void _onDeleteAllPressed() {
    setState(() {
      try {
        // Delete all entries from the database
        dbHelper.deleteAllLocations();
        // Clear the main list
        locations.clear();
        // Clear the selected locations list
        selectedLocations.clear();
        // Disable the edit mode
        isEditing = false;
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  void _selectAllLocations() {
    setState(() {
      try {
        if (selectedLocations.length == locations.length) {
          selectedLocations
              .clear(); // Clear the selection when all items are selected
        } else {
          // Select all the locations
          for (var location in locations) {
            if (!selectedLocations.contains(location)) {
              selectedLocations.add(location);
            }
          }
        }
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  void _showBottomSheet() {
    if (selectedLocations.isEmpty) {
      return; // Do nothing if no locations are selected
    }

    List<ManageLocation> favoriteLocations =
        selectedLocations.where((location) => location.isFavorite).toList();

    List<ManageLocation> otherLocations =
        selectedLocations.where((location) => !location.isFavorite).toList();

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 60,
          child: Center(
            child:
                // Conditionally render widget based on selected locations
                favoriteLocations.isNotEmpty
                    ? // If favorite locations exist
                    otherLocations.isNotEmpty
                        ? //  and other locations exist, show "Delete All" option
                        _buildDeleteAllOption()
                        : //  but other locations are empty, show "Delete" option
                        _buildDeleteOption()
                    : otherLocations.isNotEmpty
                        ? // If favorite locations are empty but other locations exist
                        otherLocations.length == 1
                            ? //  and there's only one other location, show "Set Favorite & Delete" option
                            _buildSetFavoriteAndDeleteOption()
                            : //  otherwise (multiple other locations), show "Delete All" option
                            _buildDeleteAllOption()
                        : Container(), // No locations selected, do nothing
          ),
        );
      },
    );
  }

  Future<void> _navigateToAddLocationScreen() async {
    // Navigate to AddLocationScreen and await for the result
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddLocationScreen()));

    // Reload the locations when returning from the AddLocationScreen
    _loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFD),
        leading: IconButton(
          icon: Icon(isEditing
              ? Icons.select_all_outlined
              : Icons.arrow_back_ios_new_rounded),
          onPressed: isEditing ? _selectAllLocations : _onBackArrowPressed,
        ),
        title: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Text(
                  isEditing ? "Select locations" : "Manage locations",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold),
                ))
              ],
            )),
        actions: [
          isEditing
              ? Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_rounded),
                      onPressed: _showBottomSheet,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_outlined),
                      onPressed: _toggleEditing,
                    )
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _navigateToAddLocationScreen,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _toggleEditing,
                    ),
                  ],
                )
        ],
      ),
      body: locations.isEmpty
          ? const Center(
              child: Text("Press on + to add a location.",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal)))
          : ListView(
              children: [
                if (locations.any((location) => location.isFavorite))
                  _buildSection(
                      "Favourite location",
                      locations
                          .where((location) => location.isFavorite)
                          .toList()),
                if (locations.any((location) => !location.isFavorite))
                  _buildSection(
                      "Other locations",
                      locations
                          .where((location) => !location.isFavorite)
                          .toList()),
              ],
            ),
    );
  }

  Widget _buildSection(String sectionTitle, List<ManageLocation> locations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            sectionTitle,
            style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.grey),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return isEditing
                ? _buildEditableLocationItem(locations[index])
                : _buildClickableLocationItem(locations[index]);
          },
        ),
        // Divider(),
      ],
    );
  }

  Widget _buildClickableLocationItem(ManageLocation location) {
    return GestureDetector(
      onTap: () {
        // Handle item click here
        print("Item clicked: ${location.name}");
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildLocationItem(location)),
    );
  }

  Widget _buildLocationItem(ManageLocation location) {
    return Row(
      children: [
        location.isFavorite
            ? _buildLocationIcon(_isDeviceLocationOn)
            : const SizedBox(),
        const SizedBox(
          width: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
            ),
            Text(
              location.region,
              style: const TextStyle(fontFamily: 'Roboto', color: Colors.grey),
            ),
            Text(formatDateTime(DateTime.now()),
                style:
                    const TextStyle(fontFamily: 'Roboto', color: Colors.grey)),
          ],
        ),
        const Expanded(child: SizedBox()),
        _buildWeatherInfo(
            location.useDeviceLocation,
            location.weatherCondition,
            location.currentTemperature,
            location.minTemperature,
            location.maxTemperature),
      ],
    );
  }

  Widget _buildEditableLocationItem(ManageLocation location) {
    return ListTile(
      title: Row(
        children: [
          Radio(
            value: location,
            groupValue: (selectedLocations.isNotEmpty &&
                    selectedLocations.contains(location))
                ? location
                : null,
            onChanged: (_) => _onItemTap(location),
          ),
          Expanded(
            child: Text(location.name),
          ),
        ],
      ),
      onTap: () {
        _onItemTap(location);
      },
    );
  }

  Widget _buildLocationIcon(bool useDeviceLocation) {
    // Implement logic based on the device location state
    return Icon(useDeviceLocation ? Icons.location_on : Icons.location_off);
  }

  Widget _buildWeatherInfo(bool useDeviceLocation, String weatherCondition,
      double currentTemp, double minTemp, double maxTemp) {
    // Fetch and display weather information based on device location
    return Column(
      children: [
        Row(
          children: [
            _buildWeatherIcon(weatherCondition),
            const SizedBox(
              width: 5.0,
            ),
            Text("${currentTemp.toStringAsFixed(0)}º",
                style: const TextStyle(fontFamily: 'Roboto', fontSize: 20.0)),
          ],
        ),
        Text("${maxTemp.toStringAsFixed(0)}º / ${minTemp.toStringAsFixed(0)}º",
            style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
      ],
    );
  }

  Widget _buildWeatherIcon(String weatherCondition) {
    return FutureBuilder(
        future: myLoadAsset(
            "assets/icons/${weatherCondition.toLowerCase().replaceAll(" ", "-")}.json"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Return a loading widget while the future is resolving
            return const CircularProgressIndicator(); // Or any other loading indicator
          } else if (snapshot.hasError) {
            // Handle error case if necessary
            print('Error: ${snapshot.error}');
            return const SizedBox.shrink();
          } else {
            // If the future has resolved successfully
            final assetPath = snapshot.data;
            if (assetPath != null) {
              // If assetPath is not null, display the Lottie animation
              return Lottie.asset(
                  assetPath,
                  width: 30.0,
                  height: 30.0,
                  backgroundLoading: true,
                  filterQuality: FilterQuality.high,
              );
            } else {
              // If assetPath is null, don't display anything
              return const SizedBox.shrink(); // or any other empty widget
            }
          }
        });
  }

  Widget _buildSetFavoriteAndDeleteOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            _onSetFavouritePressed();
            Navigator.pop(context);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_border_rounded),
              Text('Set as favorite', style: TextStyle(fontFamily: 'Roboto')),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            _onDeletePressed();
            Navigator.pop(context);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded),
              Text(
                'Delete',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteOption() {
    return ListTile(
      leading: const Icon(Icons.delete_outline_rounded),
      title: const Text('Delete', style: TextStyle(fontFamily: 'Roboto')),
      onTap: () {
        _onDeletePressed();
        Navigator.pop(context);
      },
    );
  }

  Widget _buildDeleteAllOption() {
    return ListTile(
      leading: const Icon(Icons.delete_outline_rounded),
      title: const Text(
        'Delete all',
        style: TextStyle(fontFamily: 'Roboto'),
      ),
      onTap: () {
        _onDeleteAllPressed();
        Navigator.pop(context);
      },
    );
  }
}
