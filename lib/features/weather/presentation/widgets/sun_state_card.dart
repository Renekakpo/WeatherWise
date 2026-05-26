import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../utils/wcolors.dart';

class SunStateCard extends StatelessWidget {
  const SunStateCard({
    super.key,
    required this.sunriseTimestamp,
    required this.sunsetTimestamp,
  });

  final int sunriseTimestamp;
  final int sunsetTimestamp;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
      padding: const EdgeInsets.all(10.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Sun(
            timestamp: sunriseTimestamp,
            assetPath: 'assets/icons/sunrise.json',
            keyValue: 'sunrise_animation_icon',
            size: width * 0.25,
          ),
          _Sun(
            timestamp: sunsetTimestamp,
            assetPath: 'assets/icons/sunset.json',
            keyValue: 'sunset_animation_icon',
            size: width * 0.25,
          ),
        ],
      ),
    );
  }
}

class _Sun extends StatelessWidget {
  const _Sun({
    required this.timestamp,
    required this.assetPath,
    required this.keyValue,
    required this.size,
  });

  final int timestamp;
  final String assetPath;
  final String keyValue;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatTimestampToHour(timestamp),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        Lottie.asset(
          assetPath,
          key: Key(keyValue),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
