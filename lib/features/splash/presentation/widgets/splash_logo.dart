import 'package:flutter/material.dart';
import '../../../../core/constants/asset_constants.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key, required this.animation, this.size = 110.0});

  final Animation<double> animation;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fade and scale from 0.90 to 1.0
    final scaleAnimation = Tween<double>(
      begin: 0.90,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(scale: scaleAnimation.value, child: child),
        );
      },
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          AssetConstants.liforaLogoTransparent,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) {
            // Safe fallback if transparent png is still being placed by user
            return Image.asset(
              AssetConstants.appLogo,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) {
                return Icon(
                  Icons.auto_stories_rounded,
                  size: size * 0.7,
                  color: theme.colorScheme.primary,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
