import 'package:flutter/material.dart';
import '../../domain/entities/memory_location.dart';

class MemoryLocationCard extends StatelessWidget {
  const MemoryLocationCard({super.key, required this.location});

  final MemoryLocation location;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _descColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38251F).withValues(alpha: 0.04),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE2CC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.place_rounded,
              color: _primaryOrange,
              size: 22,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: const TextStyle(
                    color: _titleColor,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (location.hasCoordinates) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    '${location.latitude!.toStringAsFixed(4)}, ${location.longitude!.toStringAsFixed(4)} (${location.source})',
                    style: const TextStyle(color: _descColor, fontSize: 12.0),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
