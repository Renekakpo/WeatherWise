/// Typed enumeration of every navigable route in the app. Centralizes the
/// path strings so screens never embed them literally.
enum AppRoute {
  splash('/', 'splash'),
  home('/home', 'home'),
  settings('settings', 'settings'),
  manageLocations('locations', 'manageLocations'),
  addLocation('add', 'addLocation'),
  reportWrongLocation('report', 'reportWrongLocation');

  const AppRoute(this.path, this.name);

  /// Path relative to the parent. Top-level routes start with '/'.
  final String path;

  /// Stable name used by GoRouter.goNamed / pushNamed.
  final String name;
}
