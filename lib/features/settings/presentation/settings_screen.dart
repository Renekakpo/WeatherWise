import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/strings.dart';
import '../../../core/services/share_service.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../utils/wcolors.dart';
import '../../../widgets/custom_switch_with_text.dart';
import '../domain/entities/app_settings.dart';
import '../domain/entities/temperature_unit.dart';
import 'view_model/settings_view_model.dart';
import 'widgets/about_sheet.dart';
import 'widgets/auto_refresh_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFD),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: const Text(
          Strings.weatherSettingsTitle,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: asyncSettings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load settings: $e')),
        data: (settings) => _Body(settings: settings),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsViewModelProvider.notifier);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      color: const Color(0xFFF8FAFD),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(Strings.unitsLabel),
            _Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    Strings.weatherUnitLabel,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomSwitchWithText(
                    key: const Key('weather_units_label'),
                    activeText: Strings.weatherUnitFahrenheitLabel,
                    inactiveText: Strings.weatherUnitCelsiusLabel,
                    unitValue: settings.unit.isImperial,
                    onUnitChanged: (value) {
                      notifier.setUnit(
                        TemperatureUnit.fromIsImperial(value),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            const _SectionTitle(Strings.appLabel),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconRow(
                    key: const Key('auto_refresh_item'),
                    icon: CupertinoIcons.refresh_circled,
                    label: Strings.appAutoRefreshLabel,
                    onTap: () => _showAutoRefreshSheet(context, ref, settings),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.refresh_circled, size: 20.0),
                        const SizedBox(width: 15.0),
                        const Expanded(
                          child: Text(
                            Strings.appAutoRefreshOnTheGoLabel,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17.0),
                          ),
                        ),
                        Switch(
                          activeColor: WColors.blueGray500,
                          value: settings.refreshOnTheGo,
                          onChanged: notifier.setRefreshOnTheGo,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  _IconRow(
                    icon: Icons.notifications_outlined,
                    label: Strings.appNotificationsLabel,
                    onTap: _openNotificationSettings,
                  ),
                  const SizedBox(height: 15.0),
                  _IconRow(
                    icon: CupertinoIcons.share,
                    label: Strings.appShareLabel,
                    onTap: () => ref
                        .read(shareServiceProvider)
                        .shareText(Strings.contentToShare),
                  ),
                  const SizedBox(height: 15.0),
                  _IconRow(
                    icon: Icons.info_outline_rounded,
                    label: Strings.appAboutLabel,
                    onTap: () => _showAboutSheet(context, ref),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SimpleRow(label: 'Review', onTap: () => _notImplemented(context)),
                  const SizedBox(height: 15.0),
                  _SimpleRow(label: 'Feedback', onTap: () => _notImplemented(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAutoRefreshSheet(
    BuildContext context,
    WidgetRef ref,
    AppSettings current,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => AutoRefreshSheet(
        selected: current.autoRefreshHours,
        onChanged: ref.read(settingsViewModelProvider.notifier).setAutoRefreshHours,
      ),
    );
  }

  Future<void> _showAboutSheet(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => AboutSheet(
        onOpenLicences: () async {
          final ok = await ref
              .read(urlLauncherServiceProvider)
              .open('https://github.com/Renekakpo/WeatherWise');
          if (!ok && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not launch screen!')),
            );
          }
        },
      ),
    );
  }

  void _openNotificationSettings() {
    if (Platform.isAndroid) {
      const AndroidIntent(
        action: 'android.settings.APP_NOTIFICATION_SETTINGS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
        arguments: <String, dynamic>{
          'android.provider.extra.APP_PACKAGE': 'com.example.weatherwise',
        },
      ).launch();
    } else if (Platform.isIOS) {
      FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.pendingNotificationRequests();
    }
  }

  void _notImplemented(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Not implemented yet!')),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: child,
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Icon(icon, size: 20.0),
              const SizedBox(width: 15.0),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontFamily: 'Roboto', fontSize: 17.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleRow extends StatelessWidget {
  const _SimpleRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17.0),
          ),
        ),
      ),
    );
  }
}
