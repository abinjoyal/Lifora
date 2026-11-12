import 'package:flutter/material.dart';

class PhotoSelectionBadge extends StatelessWidget {
  const PhotoSelectionBadge({
    super.key,
    required this.isSelected,
    this.orderIndex,
  });

  final bool isSelected;
  final int? orderIndex;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _darkOrange = Color(0xFFB94E2D);

  @override
  Widget build(BuildContext context) {
    if (!isSelected) {
      return Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.25),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );
    }

    return Container(
      width: 24.0,
      height: 24.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [_primaryOrange, _darkOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        orderIndex != null ? '$orderIndex' : '✓',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

