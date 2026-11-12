import 'package:flutter/material.dart';
import 'package:lifora/features/onboarding/presentation/widgets/onboarding_logo.dart';

class StorageHeader extends StatelessWidget {
  const StorageHeader({super.key, this.stepLabel = 'Step 2 of 2'});

  final String stepLabel;

  // Design Colors
  static const Color _brandTextColor = Color(0xFF38251F);
  static const Color _badgeTextColor = Color(0xFFB94E2D);
  static const Color _badgeBgColor = Color(0xFFFFE2CC);

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

          // Step Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: _badgeBgColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              stepLabel,
              style: const TextStyle(
                color: _badgeTextColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
