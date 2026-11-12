import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  // Soft glow color behind the logo
  static const Color _glowColor = Color(0xFFFFF0E8);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Extremely subtle radial ambient light glow centered behind the logo
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.38,
                  colors: [
                    _glowColor,
                    _glowColor.withValues(alpha: 0.4),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
