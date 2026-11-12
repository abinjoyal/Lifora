import 'package:flutter/material.dart';
import '../../../../core/constants/asset_constants.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key, this.size = 32.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        AssetConstants.liforaLogoTransparent,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) {
          return Image.asset(
            AssetConstants.appLogo,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) {
              return Icon(
                Icons.auto_stories_rounded,
                size: size * 0.8,
                color: theme.colorScheme.primary,
              );
            },
          );
        },
      ),
    );
  }
}
