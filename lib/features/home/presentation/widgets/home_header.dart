import 'package:flutter/material.dart';
import 'package:lifora/features/onboarding/presentation/widgets/onboarding_logo.dart';
import 'home_notification_button.dart';
import 'home_profile_button.dart';
import 'home_search_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static const Color _brandTextColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Brand Logo & Title
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OnboardingLogo(size: 32.0),
              SizedBox(width: 8.0),
              Text(
                'Lifora',
                style: TextStyle(
                  color: _brandTextColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),

          // Right: Action Buttons
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              HomeSearchButton(),
              HomeNotificationButton(),
              SizedBox(width: 4.0),
              HomeProfileButton(),
            ],
          ),
        ],
      ),
    );
  }
}
