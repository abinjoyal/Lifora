import 'package:flutter/material.dart';

class PhotoEmptyState extends StatelessWidget {
  const PhotoEmptyState({
    super.key,
    this.message = 'No photos found in this album.',
    this.onAction,
    this.actionLabel,
  });

  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE2CC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                size: 48.0,
                color: _primaryOrange,
              ),
            ),
            const SizedBox(height: 18.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF806A60),
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 18.0),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: onAction,
                icon: const Icon(Icons.add_photo_alternate_rounded, size: 18.0),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

