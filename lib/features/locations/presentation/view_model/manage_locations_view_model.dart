import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/saved_location.dart';
import '../providers/locations_providers.dart';

class ManageLocationsViewModel extends AsyncNotifier<List<SavedLocation>> {
  @override
  Future<List<SavedLocation>> build() async {
    final result = await ref.read(getSavedLocationsUseCaseProvider)();
    return result.fold(
      onSuccess: (l) => l.reversed.toList(),
      onFailure: (f) => throw f,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final r = await ref.read(getSavedLocationsUseCaseProvider)();
      return r.fold(
        onSuccess: (l) => l.reversed.toList(),
        onFailure: (f) => throw f,
      );
    });
  }

  Future<void> deleteOne(int id) async {
    final result = await ref.read(deleteLocationUseCaseProvider)(id);
    result.fold(
      onSuccess: (_) async => refresh(),
      onFailure: (f) =>
          state = AsyncError(f, StackTrace.current),
    );
  }

  Future<void> deleteAll() async {
    final result = await ref.read(deleteAllLocationsUseCaseProvider)();
    result.fold(
      onSuccess: (_) async => refresh(),
      onFailure: (f) =>
          state = AsyncError(f, StackTrace.current),
    );
  }

  Future<void> setFavorite(int id) async {
    final result = await ref.read(setFavoriteLocationUseCaseProvider)(id);
    result.fold(
      onSuccess: (_) async {
        await refresh();
        // also invalidate cross-feature favorite watcher.
        ref.invalidate(favoriteLocationProvider);
      },
      onFailure: (f) =>
          state = AsyncError(f, StackTrace.current),
    );
  }
}

final manageLocationsViewModelProvider =
    AsyncNotifierProvider<ManageLocationsViewModel, List<SavedLocation>>(
  ManageLocationsViewModel.new,
  isAutoDispose: true,
);

/// Cross-feature read of the user's favorite location. Watched by the
/// HomeScreen drawer and by the weather feature when device GPS is off.
final favoriteLocationProvider = FutureProvider<SavedLocation?>((ref) async {
  final result = await ref.watch(getFavoriteLocationUseCaseProvider)();
  return result.fold(onSuccess: (l) => l, onFailure: (f) => throw f);
});
