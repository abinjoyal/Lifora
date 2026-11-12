import 'package:flutter/material.dart';

class PhotoPermissionView extends StatelessWidget {
  const PhotoPermissionView({
    super.key,
    required this.onOpenSystemPicker,
    required this.onRequestPermission,
  });

  final VoidCallback onOpenSystemPicker;
  final VoidCallback onRequestPermission;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 50.0,
                color: _primaryOrange,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Access Your Photos',
              style: TextStyle(
                color: _titleColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Lifora respects your privacy. You can either grant access to browse your gallery albums or use the Android Photo Picker directly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF806A60),
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              onPressed: onOpenSystemPicker,
              icon: const Icon(Icons.photo_library_rounded, size: 20.0),
              label: const Text(
                'Open Photo Picker (Private)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF38251F),
                side: const BorderSide(color: Color(0xFFEADBCE)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
              onPressed: onRequestPermission,
              child: const Text('Browse Full Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}

