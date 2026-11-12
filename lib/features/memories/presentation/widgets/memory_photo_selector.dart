import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/memory_photo.dart';

class MemoryPhotoSelector extends StatelessWidget {
  const MemoryPhotoSelector({
    super.key,
    required this.photos,
    required this.newPhotoPaths,
    required this.coverPhotoId,
    required this.onAddPhotos,
    required this.onRemovePhoto,
    required this.onSetCoverPhoto,
  });

  final List<MemoryPhoto> photos;
  final List<String> newPhotoPaths;
  final String? coverPhotoId;
  final VoidCallback onAddPhotos;
  final void Function({String? photoId, String? localPath}) onRemovePhoto;
  final ValueChanged<String> onSetCoverPhoto;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context) {
    final totalCount = photos.length + newPhotoPaths.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Memory Photos',
              style: TextStyle(
                color: Color(0xFF38251F),
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$totalCount photo${totalCount == 1 ? '' : 's'} selected',
              style: const TextStyle(color: Color(0xFF806A60), fontSize: 12.5),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 94.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add Photos Button
              InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: onAddPhotos,
                child: Container(
                  width: 90.0,
                  height: 90.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE2CC).withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: _primaryOrange,
                      style: BorderStyle.solid,
                      width: 1.2,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        color: _primaryOrange,
                        size: 28,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Add Photo',
                        style: TextStyle(
                          color: _primaryOrange,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Existing Saved Photos
              ...photos.map((photo) {
                final isCover = coverPhotoId == photo.id;
                return _buildPhotoTile(
                  imagePath: photo.localPath,
                  isCover: isCover,
                  onRemove: () => onRemovePhoto(photoId: photo.id),
                  onSetCover: () => onSetCoverPhoto(photo.id),
                );
              }),

              // Newly Added Local Paths
              ...newPhotoPaths.map((path) {
                return _buildPhotoTile(
                  imagePath: path,
                  isCover: false,
                  onRemove: () => onRemovePhoto(localPath: path),
                  onSetCover: () {},
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoTile({
    required String? imagePath,
    required bool isCover,
    required VoidCallback onRemove,
    required VoidCallback onSetCover,
  }) {
    return Container(
      width: 90.0,
      height: 90.0,
      margin: const EdgeInsets.only(left: 10.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: SizedBox(
              width: 90.0,
              height: 90.0,
              child: imagePath != null && File(imagePath).existsSync()
                  ? Image.file(File(imagePath), fit: BoxFit.cover)
                  : Container(
                      color: const Color(0xFFFFE2CC),
                      child: const Icon(
                        Icons.photo_rounded,
                        color: _primaryOrange,
                      ),
                    ),
            ),
          ),

          // Cover indicator
          if (isCover)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: _primaryOrange,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: const Text(
                  'Cover',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            Positioned(
              bottom: 4,
              left: 4,
              child: GestureDetector(
                onTap: onSetCover,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Text(
                    'Set Cover',
                    style: TextStyle(color: Colors.white, fontSize: 9.0),
                  ),
                ),
              ),
            ),

          // Delete Button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
