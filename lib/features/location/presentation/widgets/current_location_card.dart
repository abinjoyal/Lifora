import 'package:flutter/material.dart';
import '../../domain/entities/memory_location.dart';

class CurrentLocationCard extends StatelessWidget {
  const CurrentLocationCard({
    super.key,
    required this.onTap,
    this.isLoading = false,
    this.currentLocation,
  });

  final VoidCallback onTap;
  final bool isLoading;
  final MemoryLocation? currentLocation;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _bodyColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22.0,
                      height: 22.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
                      ),
                    )
                  : const Icon(Icons.my_location_rounded, color: _primaryOrange, size: 22.0),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Use Current Location',
                    style: TextStyle(
                      color: _titleColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    currentLocation != null
                        ? (currentLocation!.address ?? currentLocation!.name)
                        : 'Detect GPS coordinates and address automatically',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _bodyColor,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14.0, color: _bodyColor),
          ],
        ),
      ),
    );
  }
}

