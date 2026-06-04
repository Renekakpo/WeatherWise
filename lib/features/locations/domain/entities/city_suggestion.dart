class CitySuggestion {
  const CitySuggestion({
    required this.name,
    required this.adminName,
    required this.countryName,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String adminName;
  final String countryName;
  final double latitude;
  final double longitude;

  String get displaySubtitle {
    if (adminName.isEmpty) return countryName;
    return '$adminName, $countryName';
  }
}
