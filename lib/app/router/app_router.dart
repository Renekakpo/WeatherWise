import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/locations/presentation/add_location_screen.dart';
import '../../features/locations/presentation/manage_locations_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/support/presentation/report_wrong_location_screen.dart';
import '../../features/weather/presentation/home_screen.dart';
import 'routes.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (_, __) => const SafeArea(child: SplashScreen()),
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: AppRoute.settings.path,
            name: AppRoute.settings.name,
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppRoute.manageLocations.path,
            name: AppRoute.manageLocations.name,
            builder: (_, __) => const ManageLocationsScreen(),
            routes: [
              GoRoute(
                path: AppRoute.addLocation.path,
                name: AppRoute.addLocation.name,
                builder: (_, __) => const AddLocationScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoute.reportWrongLocation.path,
            name: AppRoute.reportWrongLocation.name,
            builder: (_, __) => const ReportWrongLocationScreen(),
          ),
        ],
      ),
    ],
  );
});
