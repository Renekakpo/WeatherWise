import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final bool fullWidth;
  final double? height;
  final Function()? onPressed;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.fullWidth,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double mWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: fullWidth ? mWidth : mWidth / 3,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900],
            shadowColor: Colors.blueAccent,
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
        child: Text(
          buttonText,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
    );
  }
}

