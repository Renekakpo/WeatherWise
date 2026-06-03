import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mounts [child] inside a ProviderScope + MaterialApp suitable for widget
/// tests. Pass [overrides] to inject mocks for providers the widget reads.
Future<void> pumpApp(
  WidgetTester tester, {
  required Widget child,
  List<Override> overrides = const [],
}) {
  return tester.pumpWidget(
    ProviderScope(
      retry: (_, __) => null,
      overrides: overrides,
      child: MaterialApp(home: child),
    ),
  );
}
