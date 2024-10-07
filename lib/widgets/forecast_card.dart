import 'package:flutter/material.dart';
import 'package:weatherwise/models/forecast_data.dart';

import '../helpers/utils_helper.dart';
import '../utils/wcolors.dart';
import 'forecast_data_item.dart';

class ForecastCard extends StatefulWidget {
  final Map<String, List<ForecastItem>> forecastItems;

  const ForecastCard({super.key, required this.forecastItems});

  @override
  State<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard> {
  int selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 25.0, right: 25.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0),
          color: WColors.blueGray300,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListView.builder(
                key: const Key('list_of_days'),
                scrollDirection: Axis.horizontal,
                itemCount: widget.forecastItems.keys.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        // Format the date from timestamp
                        getDayNameFromTimestamp(widget
                            .forecastItems[
                                widget.forecastItems.keys.toList()[index]]!
                            .first
                            .dt),
                        style: TextStyle(
                            color: index == selectedDayIndex
                                ? WColors.blueGray900
                                : Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: Colors.white.withOpacity(0.3),
              height: 0.1,
            ),
            // Data section for selected day
            SizedBox(
              key: const Key('selected_day_weather_data'),
              height: MediaQuery.of(context).size.width / 2.5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget
                    .forecastItems[
                        widget.forecastItems.keys.toList()[selectedDayIndex]]!
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  return ForecastDataItem(
                      data: widget.forecastItems[widget.forecastItems.keys
                          .toList()[selectedDayIndex]]![index]);
                },
              ),
            ),
          ],
        ));
  }
}
