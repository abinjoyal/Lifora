import 'package:flutter/material.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  // Secondary Text Color
  static const Color _skipColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: _skipColor,
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        minimumSize: const Size(48, 36),
      ),
      child: const Text(
        'Skip',
        style: TextStyle(
          color: _skipColor,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
