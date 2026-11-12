import 'package:flutter/material.dart';

class LocationMarker extends StatelessWidget {
  const LocationMarker({super.key, this.size = 44.0});

  final double size;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _darkOrange = Color(0xFFB94E2D);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [_primaryOrange, _darkOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white, width: 3.0),
            boxShadow: [
              BoxShadow(
                color: _primaryOrange.withValues(alpha: 0.4),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 22.0,
            ),
          ),
        ),
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _darkOrange.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

