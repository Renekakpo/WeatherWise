import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../network/http_client.dart';

class NotificationService {
  NotificationService({
    required FlutterLocalNotificationsPlugin plugin,
    required http.Client httpClient,
  })  : _plugin = plugin,
        _httpClient = httpClient;

  final FlutterLocalNotificationsPlugin _plugin;
  final http.Client _httpClient;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings: settings);
    await _requestPermissions();
    _initialized = true;
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showWeatherNotification({
    required String title,
    required String body,
    required String weatherIconUrl,
    required int notificationId,
  }) async {
    final iconBytes = await _downloadIcon(weatherIconUrl);
    if (iconBytes == null) {
      if (kDebugMode) debugPrint('NotificationService: icon download failed');
      return;
    }

    final android = AndroidNotificationDetails(
      'weather_channel_id',
      'WeatherWise Notifications',
      channelDescription: 'Channel for WeatherWise notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: ByteArrayAndroidBitmap(iconBytes.buffer.asUint8List()),
    );

    final ios = DarwinNotificationDetails(
      attachments: [DarwinNotificationAttachment(await _saveIconToTempFile(iconBytes))],
    );

    await _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: android, iOS: ios),
    );
  }

  Future<ByteData?> _downloadIcon(String url) async {
    try {
      final response = await _httpClient.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return ByteData.view(response.bodyBytes.buffer);
      }
      if (kDebugMode) {
        debugPrint('NotificationService: icon HTTP ${response.statusCode}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('NotificationService: download error: $e');
      return null;
    }
  }

  Future<String> _saveIconToTempFile(ByteData data) async {
    final tempPath = (await getTemporaryDirectory()).path;
    final file = File('$tempPath/weather_icon.png');
    await file.writeAsBytes(data.buffer.asUint8List());
    return file.path;
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    plugin: FlutterLocalNotificationsPlugin(),
    httpClient: ref.watch(httpClientProvider),
  );
});
