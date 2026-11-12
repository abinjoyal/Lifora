import 'package:flutter/material.dart';

class PhotoPickerHeader extends StatelessWidget {
  const PhotoPickerHeader({
    super.key,
    required this.selectedCount,
    required this.onBack,
    required this.onDone,
  });

  final int selectedCount;
  final VoidCallback onBack;
  final VoidCallback onDone;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _titleColor, size: 22),
            tooltip: 'Back',
            onPressed: onBack,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Photos',
                style: TextStyle(
                  color: _titleColor,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              if (selectedCount > 0)
                Text(
                  '$selectedCount selected',
                  style: const TextStyle(
                    color: _primaryOrange,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          TextButton(
            onPressed: selectedCount > 0 ? onDone : null,
            style: TextButton.styleFrom(
              foregroundColor: _primaryOrange,
              disabledForegroundColor: const Color(0xFFB0A29A),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15.0,
              ),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

