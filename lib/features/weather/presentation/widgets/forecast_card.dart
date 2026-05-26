import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/forecast.dart';

class ForecastCard extends StatefulWidget {
  const ForecastCard({super.key, required this.groupedByDay});

  final Map<String, List<ForecastEntry>> groupedByDay;

  @override
  State<ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<ForecastCard> {
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    final dayKeys = widget.groupedByDay.keys.toList();
    if (dayKeys.isEmpty) return const SizedBox.shrink();
    final selectedEntries = widget.groupedByDay[dayKeys[_selectedDay]]!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 25.0, right: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: WColors.blueGray300,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              key: const Key('list_of_days'),
              scrollDirection: Axis.horizontal,
              itemCount: dayKeys.length,
              itemBuilder: (context, i) {
                final first = widget.groupedByDay[dayKeys[i]]!.first;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDay = i),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      getDayNameFromTimestamp(first.timestamp),
                      style: TextStyle(
                        color: i == _selectedDay
                            ? WColors.blueGray900
                            : Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.3), height: 0.1),
          SizedBox(
            key: const Key('selected_day_weather_data'),
            height: MediaQuery.of(context).size.width / 2.5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedEntries.length,
              itemBuilder: (context, i) {
                final entry = selectedEntries[i];
                return _Entry(entry: entry);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({required this.entry});
  final ForecastEntry entry;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          Text(formatTimestampToHour(entry.timestamp), style: textStyle),
          const SizedBox(height: 10.0),
          Image.network(
            entry.iconUrl,
            width: width * 0.1,
            height: width * 0.1,
            errorBuilder: (_, __, ___) => SizedBox(width: width * 0.1, height: width * 0.1),
          ),
          const SizedBox(height: 10.0),
          Text('${entry.temperature.round()}º', style: textStyle),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/icons/raindrop.json',
                width: 30.0,
                height: 30.0,
              ),
              Text(
                '${(entry.precipitationProbability * 100).toStringAsFixed(0)}%',
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
