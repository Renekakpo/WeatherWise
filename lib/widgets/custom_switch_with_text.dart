import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitchWithText extends StatefulWidget {
  final Function(bool) onUnitChanged;
  final bool unitValue;
  final String activeText;
  final String inactiveText;

  const CustomSwitchWithText(
      {super.key,
      required this.unitValue,
      required this.onUnitChanged,
      required this.activeText,
      required this.inactiveText});

  @override
  State<CustomSwitchWithText> createState() => _CustomSwitchWithTextState();
}

class _CustomSwitchWithTextState extends State<CustomSwitchWithText> {
  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
        width: 75.0,
        height: 30.0,
        valueFontSize: 17.0,
        toggleSize: 30.0,
        borderRadius: 25.0,
        padding: 0.5,
        showOnOff: true,
        activeIcon: Text(
          widget.activeText,
          style:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        activeText: widget.inactiveText,
        activeTextColor: Colors.grey.shade500,
        activeTextFontWeight: FontWeight.w500,
        activeColor: Colors.grey.shade100,
        inactiveIcon: Text(widget.inactiveText,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white)),
        inactiveText: widget.activeText,
        inactiveTextColor: Colors.grey.shade500,
        inactiveColor: Colors.grey.shade100,
        inactiveTextFontWeight: FontWeight.w500,
        toggleColor: Colors.blue,
        value: widget.unitValue,
        onToggle: (val) {
          widget.onUnitChanged(val);
        });
  }
}
