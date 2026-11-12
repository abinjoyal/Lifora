import 'package:flutter/material.dart';

class ShortcutItem extends StatelessWidget {
  const ShortcutItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFFF47B45),
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  static const Color _textColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.0),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 6.0,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38251F).withValues(alpha: 0.04),
                  blurRadius: 10.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(height: 8.0),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
