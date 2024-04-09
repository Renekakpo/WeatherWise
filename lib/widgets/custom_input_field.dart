import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String placeholder;
  final bool isPasswordField;
  final bool isMultilineField;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const CustomInputField(
      {super.key,
        required this.placeholder,
        required this.isPasswordField,
        required this.onChanged,
        required this.validator,
        required this.isMultilineField,
      });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final inputController = TextEditingController();
  bool _isPasswordVisible = false;

  void _changePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: inputController,
        onChanged: widget.onChanged,
        obscureText: widget.isPasswordField ? !_isPasswordVisible : false,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            hintText: widget.placeholder,
            contentPadding: const EdgeInsets.all(15.0),
            filled: true,
            fillColor: const Color(0xFFF8FAFD),
            suffixIcon: widget.isPasswordField
                ? IconButton(
                onPressed: () {
                  _changePasswordVisibility();
                },
                icon: Icon(_isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off_outlined))
                : null),
        validator: widget.validator,
      maxLines: widget.isMultilineField ? 3 : 1,
      keyboardType: widget.isMultilineField ? TextInputType.multiline : null,
    );
  }
}
