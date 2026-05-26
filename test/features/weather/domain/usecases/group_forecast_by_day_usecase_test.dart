import 'package:flutter_test/flutter_test.dart';
import 'package:weatherwise/features/weather/domain/entities/forecast.dart';
import 'package:weatherwise/features/weather/domain/usecases/group_forecast_by_day_usecase.dart';

ForecastEntry entry(int ts) => ForecastEntry(
      timestamp: ts,
      temperature: 0,
      tempMin: 0,
      tempMax: 0,
      condition: '',
      iconId: '',
      precipitationProbability: 0,
      windSpeed: 0,
    );

void main() {
  test('groups entries by local calendar day', () {
    final dayA = DateTime(2024, 6, 1, 10).millisecondsSinceEpoch ~/ 1000;
    final dayANight = DateTime(2024, 6, 1, 22).millisecondsSinceEpoch ~/ 1000;
    final dayB = DateTime(2024, 6, 2, 8).millisecondsSinceEpoch ~/ 1000;

    final result = const GroupForecastByDayUseCase()(
      Forecast(entries: [entry(dayA), entry(dayANight), entry(dayB)]),
    );

    expect(result.keys, hasLength(2));
    expect(result['2024-06-01'], hasLength(2));
    expect(result['2024-06-02'], hasLength(1));
  });

  test('handles empty forecast', () {
    final result =
        const GroupForecastByDayUseCase()(const Forecast(entries: []));
    expect(result, isEmpty);
  });
}
