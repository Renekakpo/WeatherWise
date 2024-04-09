import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final String title;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;

  const CustomRadioButton({super.key,
  required this.title,
  required this.value,
  required this.groupValue,
  required this.onChanged,
  });

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title, style: const TextStyle(fontFamily: 'Roboto'),),
      trailing: Radio(
        value: widget.value,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}
