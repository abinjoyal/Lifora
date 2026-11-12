import 'package:flutter/material.dart';
import 'onboarding_logo.dart';
import 'onboarding_skip_button.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    required this.onSkip,
    this.showSkip = true,
  });

  final VoidCallback onSkip;
  final bool showSkip;

  // Main Brand Text Color
  static const Color _brandTextColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Brand Name
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OnboardingLogo(size: 30.0),
              SizedBox(width: 8.0),
              Text(
                'Lifora',
                style: TextStyle(
                  color: _brandTextColor,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          // Skip Button
          if (showSkip)
            OnboardingSkipButton(onPressed: onSkip)
          else
            const SizedBox(width: 48, height: 36),
        ],
      ),
    );
  }
}
