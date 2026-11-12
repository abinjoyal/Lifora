import 'package:flutter/material.dart';

class SplashLoadingIndicator extends StatelessWidget {
  const SplashLoadingIndicator({
    super.key,
    this.size = 24.0,
    this.strokeWidth = 2.5,
  });

  final double size;
  final double strokeWidth;

  // Primary Orange Indicator Color
  static const Color _indicatorColor = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: const AlwaysStoppedAnimation<Color>(_indicatorColor),
      ),
    );
  }
}
