import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppDimensions.cardPadding,
    this.margin,
    this.borderRadius = AppDimensions.borderRadiusMedium,
    this.backgroundColor,
    this.borderColor,
    this.elevation = AppDimensions.elevationLow,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor =
        backgroundColor ?? theme.cardTheme.color ?? theme.colorScheme.surface;
    final outlineColor =
        borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.5);

    Widget content = Padding(padding: padding, child: child);

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: borderRadius,
        border: Border.all(color: outlineColor, width: 0.5),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(
                    alpha: 0.06 * elevation,
                  ),
                  blurRadius: 4.0 * elevation,
                  offset: Offset(0, 1.5 * elevation),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(color: Colors.transparent, child: content),
      ),
    );
  }
}
