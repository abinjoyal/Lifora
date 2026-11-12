import 'package:flutter/material.dart';

class OnboardingTitle extends StatelessWidget {
  const OnboardingTitle({super.key, required this.title});

  final String title;

  // Main Text Color
  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _titleColor,
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.25,
        ),
      ),
    );
  }
}
