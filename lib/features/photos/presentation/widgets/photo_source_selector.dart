import 'package:flutter/material.dart';

enum PhotoSourceChoice { gallery, camera }

class PhotoSourceSelector extends StatelessWidget {
  const PhotoSourceSelector({super.key, required this.onSelectSource});

  final ValueChanged<PhotoSourceChoice> onSelectSource;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  static Future<PhotoSourceChoice?> show(BuildContext context) {
    return showModalBottomSheet<PhotoSourceChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PhotoSourceSelector(
        onSelectSource: (choice) => Navigator.pop(ctx, choice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: const Color(0xFFE0D5CC),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Add Photos',
            style: TextStyle(
              color: _titleColor,
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: _buildChoiceCard(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  subtitle: 'Pick from device albums',
                  onTap: () => onSelectSource(PhotoSourceChoice.gallery),
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: _buildChoiceCard(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  subtitle: 'Take a new photo',
                  onTap: () => onSelectSource(PhotoSourceChoice.camera),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F1),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _primaryOrange, size: 26.0),
            ),
            const SizedBox(height: 12.0),
            Text(
              label,
              style: const TextStyle(
                color: _titleColor,
                fontWeight: FontWeight.w700,
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF806A60),
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

