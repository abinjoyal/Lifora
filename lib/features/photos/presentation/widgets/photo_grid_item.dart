import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/photo.dart';
import 'photo_selection_badge.dart';

class PhotoGridItem extends StatelessWidget {
  const PhotoGridItem({
    super.key,
    required this.photo,
    required this.isSelected,
    this.orderIndex,
    required this.onTap,
    this.onLongPress,
  });

  final Photo photo;
  final bool isSelected;
  final int? orderIndex;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? _primaryOrange : Colors.transparent,
            width: isSelected ? 2.5 : 0.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _primaryOrange.withValues(alpha: 0.3),
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 9.5 : 12.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image Thumbnail
              _buildImage(),

              // Semi-transparent overlay when selected
              if (isSelected)
                Container(
                  color: Colors.black.withValues(alpha: 0.15),
                ),

              // Selection Badge in Top Right
              Positioned(
                top: 8.0,
                right: 8.0,
                child: PhotoSelectionBadge(
                  isSelected: isSelected,
                  orderIndex: orderIndex,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (photo.path.startsWith('content://')) {
      // Content URI via Flutter's image file provider or icon fallback
      return Image.file(
        File(photo.path),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: const Color(0xFFFFE2CC),
          child: const Center(
            child: Icon(Icons.image_rounded, color: Color(0xFFB94E2D)),
          ),
        ),
      );
    }

    final file = File(photo.path);
    return Image.file(
      file,
      fit: BoxFit.cover,
      cacheWidth: 300,
      cacheHeight: 300,
      errorBuilder: (_, _, _) => Container(
        color: const Color(0xFFFFE2CC),
        child: const Center(
          child: Icon(Icons.image_rounded, color: Color(0xFFB94E2D)),
        ),
      ),
    );
  }
}

