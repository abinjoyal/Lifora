import 'package:flutter/material.dart';
import '../../domain/entities/photo.dart';
import 'photo_grid_item.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({
    super.key,
    required this.photos,
    required this.selectedPhotoIds,
    required this.onTogglePhoto,
    this.onPreviewPhoto,
  });

  final List<Photo> photos;
  final List<String> selectedPhotoIds;
  final ValueChanged<Photo> onTogglePhoto;
  final ValueChanged<Photo>? onPreviewPhoto;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final isSelected = selectedPhotoIds.contains(photo.id);
        final orderIndex = isSelected
            ? selectedPhotoIds.indexOf(photo.id) + 1
            : null;

        return PhotoGridItem(
          photo: photo,
          isSelected: isSelected,
          orderIndex: orderIndex,
          onTap: () => onTogglePhoto(photo),
          onLongPress: onPreviewPhoto != null ? () => onPreviewPhoto!(photo) : null,
        );
      },
    );
  }
}

