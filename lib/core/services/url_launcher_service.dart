import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  const UrlLauncherService();

  Future<bool> open(String url) {
    return launchUrl(Uri.parse(url));
  }
}

final urlLauncherServiceProvider = Provider<UrlLauncherService>((_) {
  return const UrlLauncherService();
});
