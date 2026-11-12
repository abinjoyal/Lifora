import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/photo.dart';

class SelectedPhotoThumbnail extends StatelessWidget {
  const SelectedPhotoThumbnail({
    super.key,
    required this.photo,
    required this.isCover,
    required this.onRemove,
    required this.onSetCover,
  });

  final Photo photo;
  final bool isCover;
  final VoidCallback onRemove;
  final VoidCallback onSetCover;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onSetCover,
          child: Container(
            width: 58.0,
            height: 58.0,
            margin: const EdgeInsets.only(top: 6.0, right: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: isCover ? _primaryOrange : const Color(0xFFEADBCE),
                width: isCover ? 2.0 : 1.0,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                File(photo.path),
                fit: BoxFit.cover,
                cacheWidth: 120,
                cacheHeight: 120,
                errorBuilder: (_, _, _) => Container(
                  color: const Color(0xFFFFE2CC),
                  child: const Icon(Icons.image, size: 20, color: _primaryOrange),
                ),
              ),
            ),
          ),
        ),

        // Remove button in top-right
        Positioned(
          top: 0.0,
          right: 2.0,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, size: 12.0, color: Colors.white),
            ),
          ),
        ),

        // Cover Photo Badge in bottom-left
        if (isCover)
          Positioned(
            bottom: 4.0,
            left: 4.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.5),
              decoration: BoxDecoration(
                color: _primaryOrange,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, size: 10.0, color: Colors.white),
                  SizedBox(width: 2.0),
                  Text(
                    'Cover',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

