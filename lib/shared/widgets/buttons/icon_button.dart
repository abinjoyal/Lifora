import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.size = 44.0,
    this.iconSize = AppDimensions.iconMedium,
    this.borderRadius = AppDimensions.borderRadiusMedium,
    this.hasBorder = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final BorderRadius borderRadius;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.onSurface;
    final effectiveBgColor = backgroundColor ?? Colors.transparent;

    Widget button = Material(
      color: effectiveBgColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: hasBorder
              ? BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                )
              : null,
          child: Icon(
            icon,
            size: iconSize,
            color: onPressed != null
                ? effectiveIconColor
                : theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
