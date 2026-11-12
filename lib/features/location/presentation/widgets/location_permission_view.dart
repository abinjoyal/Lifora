import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionView extends StatelessWidget {
  const LocationPermissionView({
    super.key,
    required this.onRetry,
    required this.onOpenSettings,
  });

  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);
  static const Color _bodyColor = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.location_off_rounded,
            color: Colors.red,
            size: 36.0,
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Location Access Required',
            style: TextStyle(
              color: _titleColor,
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 6.0),
          const Text(
            'GPS location is disabled or permission was denied. You can grant access in device settings or enter your location manually.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _bodyColor, fontSize: 12.5, height: 1.4),
          ),
          const SizedBox(height: 14.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Geolocator.openLocationSettings(),
                child: const Text('Location Settings'),
              ),
              const SizedBox(width: 12.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  foregroundColor: Colors.white,
                ),
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

