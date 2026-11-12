import 'package:flutter/material.dart';

class LocationPickerHeader extends StatelessWidget {
  const LocationPickerHeader({
    super.key,
    required this.onBack,
    this.onSkip,
    this.title = 'Add Location',
  });

  final VoidCallback onBack;
  final VoidCallback? onSkip;
  final String title;

  static const Color _titleColor = Color(0xFF38251F);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _titleColor, size: 20),
            onPressed: onBack,
          ),
          Text(
            title,
            style: const TextStyle(
              color: _titleColor,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          if (onSkip != null)
            TextButton(
              onPressed: onSkip,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: _primaryOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            )
          else
            const SizedBox(width: 48.0),
        ],
      ),
    );
  }
}

