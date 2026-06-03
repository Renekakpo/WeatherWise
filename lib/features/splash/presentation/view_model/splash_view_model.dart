import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/permission_service.dart';

sealed class SplashState {
  const SplashState();
}

class SplashChecking extends SplashState {
  const SplashChecking();
}

class SplashPermissionGranted extends SplashState {
  const SplashPermissionGranted();
}

class SplashPermissionDenied extends SplashState {
  const SplashPermissionDenied();
}

class SplashPermissionPermanentlyDenied extends SplashState {
  const SplashPermissionPermanentlyDenied();
}

class SplashViewModel extends Notifier<SplashState>
    with WidgetsBindingObserver {
  bool _openedSettings = false;

  @override
  SplashState build() {
    final binding = WidgetsBinding.instance..addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));

    // Kick off the first permission check on the next frame so listeners are
    // attached before the state transitions.
    Future.microtask(check);

    return const SplashChecking();
  }

  Future<void> check() async {
    final service = ref.read(permissionServiceProvider);
    state = const SplashChecking();
    if (await service.isLocationPermissionGranted()) {
      state = const SplashPermissionGranted();
      return;
    }
    final granted = await service.requestLocationPermission();
    if (granted) {
      state = const SplashPermissionGranted();
      return;
    }
    if (await service.isLocationPermanentlyDenied()) {
      _openedSettings = true;
      await service.openSettings();
      state = const SplashPermissionPermanentlyDenied();
    } else {
      state = const SplashPermissionDenied();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _openedSettings) {
      _openedSettings = false;
      check();
    }
  }
}

final splashViewModelProvider =
    NotifierProvider<SplashViewModel, SplashState>(
  SplashViewModel.new,
  isAutoDispose: true,
);
