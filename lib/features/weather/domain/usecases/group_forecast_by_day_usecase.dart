import 'package:intl/intl.dart';

import '../entities/forecast.dart';

/// Pure transformation: groups forecast entries by calendar day (yyyy-MM-dd
/// in local time). The legacy app expected a Map<String, List<...>> ordered
/// chronologically; we preserve that contract.
class GroupForecastByDayUseCase {
  const GroupForecastByDayUseCase();

  Map<String, List<ForecastEntry>> call(Forecast forecast) {
    final grouped = <String, List<ForecastEntry>>{};
    for (final entry in forecast.entries) {
      final dt = DateTime.fromMillisecondsSinceEpoch(entry.timestamp * 1000)
          .toLocal();
      final key = DateFormat('yyyy-MM-dd').format(dt);
      grouped.putIfAbsent(key, () => []).add(entry);
    }
    return grouped;
  }
}
