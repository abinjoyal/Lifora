import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/memory_photo.dart';

class MemoryPhotoGallery extends StatelessWidget {
  const MemoryPhotoGallery({super.key, required this.photos});

  final List<MemoryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Photos (${photos.length})',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: Color(0xFF38251F),
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: 110.0,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10.0),
            itemBuilder: (context, index) {
              final photo = photos[index];
              return InkWell(
                borderRadius: BorderRadius.circular(14.0),
                onTap: () => _openFullScreen(context, photo),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: SizedBox(
                    width: 110.0,
                    height: 110.0,
                    child:
                        photo.localPath != null &&
                            File(photo.localPath!).existsSync()
                        ? Image.file(File(photo.localPath!), fit: BoxFit.cover)
                        : Container(
                            color: const Color(0xFFFFE2CC),
                            child: const Icon(
                              Icons.photo_rounded,
                              color: Color(0xFFF47B45),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openFullScreen(BuildContext context, MemoryPhoto photo) {
    if (photo.localPath == null || !File(photo.localPath!).existsSync()) return;

    showDialog<void>(
      context: context,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.file(File(photo.localPath!)),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
