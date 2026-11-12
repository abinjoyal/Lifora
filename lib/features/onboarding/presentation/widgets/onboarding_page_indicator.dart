import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    this.pageCount = 3,
  });

  final int currentPage;
  final int pageCount;

  // Design Colors
  static const Color _activeColor = Color(0xFFF47B45);
  static const Color _inactiveColor = Color(0xFFFFE2CC);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final bool isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isActive ? _activeColor : _inactiveColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
