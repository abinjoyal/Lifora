import 'package:flutter/material.dart';

class OnboardingDescription extends StatelessWidget {
  const OnboardingDescription({super.key, required this.description});

  final String description;

  // Secondary Text Color
  static const Color _descriptionColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 340.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _descriptionColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          height: 1.45,
        ),
      ),
    );
  }
}
