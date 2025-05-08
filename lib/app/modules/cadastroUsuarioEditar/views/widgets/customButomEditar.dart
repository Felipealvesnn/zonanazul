import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonStyle style;

  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.style,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 30,
              child: CircularProgressIndicator(),
            )
          : Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
    );
  }

 
}
