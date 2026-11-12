import 'package:flutter/material.dart';
import '../../domain/entities/memory_location.dart';

class LocationDetailsCard extends StatelessWidget {
  const LocationDetailsCard({
    super.key,
    required this.location,
    required this.onChangeLocation,
    this.onClearLocation,
  });

  final MemoryLocation location;
  final VoidCallback onChangeLocation;
  final VoidCallback? onClearLocation;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _bodyColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: _primaryOrange.withValues(alpha: 0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _primaryOrange.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE2CC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: _primaryOrange,
                  size: 20.0,
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
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (location.address != null &&
                        location.address!.isNotEmpty) ...[
                      const SizedBox(height: 4.0),
                      Text(
                        location.address!,
                        style: const TextStyle(
                          color: _bodyColor,
                          fontSize: 13.0,
                          height: 1.3,
                        ),
                      ),
                    ],
                    if (location.hasCoordinates) ...[
                      const SizedBox(height: 6.0),
                      Text(
                        '${location.latitude!.toStringAsFixed(4)}°, ${location.longitude!.toStringAsFixed(4)}°',
                        style: TextStyle(
                          color: _primaryOrange.withValues(alpha: 0.9),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onClearLocation != null)
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: _bodyColor),
                  onPressed: onClearLocation,
                ),
            ],
          ),
          const SizedBox(height: 12.0),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onChangeLocation,
              icon: const Icon(Icons.edit_location_alt_rounded, size: 16, color: _primaryOrange),
              label: const Text(
                'Change Location',
                style: TextStyle(
                  color: _primaryOrange,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

