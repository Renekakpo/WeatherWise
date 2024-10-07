import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final NotificationHelper _instance = NotificationHelper._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final http.Client _httpClient;

  factory NotificationHelper({http.Client? httpClient, FlutterLocalNotificationsPlugin? flutterPlugin}) => _instance;

  NotificationHelper._internal({http.Client? httpClient, FlutterLocalNotificationsPlugin? flutterPlugin})
      : _flutterLocalNotificationsPlugin = flutterPlugin ?? FlutterLocalNotificationsPlugin(),
        _httpClient = httpClient ?? http.Client();

  Future<void> initialize(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    // Request notification permission on Android 13+ and iOS
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request notification permission on Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Request notification permission on iOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showWeatherNotification({
    required String title,
    required String body,
    required String weatherIconUrl,
    required int notificationId,
  }) async {
    final ByteData? iconData = await downloadAndConvertToBytes(weatherIconUrl);
    if (iconData == null) {
      if (kDebugMode) {
        print('Failed to download weather icon');
      }
      return;
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'weather_channel_id',
      'WeatherWise Notifications',
      channelDescription: 'Channel for WeatherWise notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher', // Set the small icon here
      largeIcon: ByteArrayAndroidBitmap(iconData.buffer.asUint8List()),
    );

    // For iOS, use an attachment for the image
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(
      attachments: [
        IOSNotificationAttachment(
          await _saveImageToTempFile(iconData),
        ),
      ],
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
    );

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<ByteData?> downloadAndConvertToBytes(String url) async {
    try {
      final Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        return ByteData.view(response.bodyBytes.buffer);
      } else {
        if (kDebugMode) {
          print('Failed to load image: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading image: $e');
      }
      return null;
    }
  }

  Future<String> _saveImageToTempFile(ByteData imageData) async {
    // Delay execution to ensure the platform is ready
    await Future.delayed(const Duration(milliseconds: 500));

    final String tempPath = (await getTemporaryDirectory()).path;
    final File file = File('$tempPath/weather_icon.png');
    await file.writeAsBytes(imageData.buffer.asUint8List());
    return file.path;
  }
}