import 'package:flutter/material.dart';
import '../../domain/entities/photo_album.dart';

class PhotoAlbumSelector extends StatelessWidget {
  const PhotoAlbumSelector({
    super.key,
    required this.selectedAlbum,
    required this.onTap,
    required this.onCameraTap,
  });

  final PhotoAlbum? selectedAlbum;
  final VoidCallback onTap;
  final VoidCallback onCameraTap;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context) {
    final albumTitle = selectedAlbum?.name ?? 'All Photos';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 16.0,
                    color: _primaryOrange,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    albumTitle,
                    style: const TextStyle(
                      color: _titleColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 18.0,
                    color: Color(0xFF806A60),
                  ),
                ],
              ),
            ),
          ),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFFFE2CC),
              foregroundColor: _primaryOrange,
            ),
            icon: const Icon(Icons.camera_alt_rounded, size: 20.0),
            tooltip: 'Take Photo',
            onPressed: onCameraTap,
          ),
        ],
      ),
    );
  }
}

