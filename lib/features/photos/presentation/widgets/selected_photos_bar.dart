import 'package:flutter/material.dart';
import '../../domain/entities/photo.dart';
import 'selected_photo_thumbnail.dart';

class SelectedPhotosBar extends StatelessWidget {
  const SelectedPhotosBar({
    super.key,
    required this.selectedPhotos,
    required this.coverPhotoId,
    required this.onRemovePhoto,
    required this.onSetCoverPhoto,
    required this.onConfirm,
  });

  final List<Photo> selectedPhotos;
  final String? coverPhotoId;
  final ValueChanged<String> onRemovePhoto;
  final ValueChanged<String> onSetCoverPhoto;
  final VoidCallback onConfirm;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    if (selectedPhotos.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFEADBCE), width: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedPhotos.length} selected (tap to set cover)',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF806A60),
                  ),
                ),
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add to Memory (${selectedPhotos.length})',
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 66.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedPhotos.length,
                itemBuilder: (context, index) {
                  final photo = selectedPhotos[index];
                  final isCover = (coverPhotoId != null &&
                          coverPhotoId == photo.id) ||
                      (coverPhotoId == null && index == 0);

                  return SelectedPhotoThumbnail(
                    photo: photo,
                    isCover: isCover,
                    onRemove: () => onRemovePhoto(photo.id),
                    onSetCover: () => onSetCoverPhoto(photo.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

