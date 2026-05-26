import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../widgets/custom_radio_button.dart';

class AutoRefreshSheet extends StatelessWidget {
  const AutoRefreshSheet({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  static const _options = <_Option>[
    _Option(0, Strings.neverLabel),
    _Option(1, Strings.everyHourLabel),
    _Option(3, Strings.everyThreeHourLabel),
    _Option(6, Strings.everySixHourLabel),
    _Option(12, Strings.everyTwelveHourLabel),
    _Option(24, Strings.everyTwentyFourHourLabel),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              Strings.appAutoRefreshLabel,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            for (final option in _options)
              CustomRadioButton(
                title: option.label,
                value: option.value,
                groupValue: selected,
                onChanged: (v) {
                  if (v != null) {
                    onChanged(v);
                    Navigator.pop(context);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Option {
  const _Option(this.value, this.label);
  final int value;
  final String label;
}
