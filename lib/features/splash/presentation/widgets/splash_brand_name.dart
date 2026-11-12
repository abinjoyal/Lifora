import 'package:flutter/material.dart';

class SplashBrandName extends StatelessWidget {
  const SplashBrandName({super.key, required this.animation});

  final Animation<double> animation;

  // Exact Brand Text Color
  static const Color _brandTextColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    // Staggered slide upward (10dp -> 0dp) and fade-in
    final slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: const Text(
          'Lifora',
          style: TextStyle(
            color: _brandTextColor,
            fontSize: 34.0,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
