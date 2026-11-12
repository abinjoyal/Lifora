import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/photo.dart';

class PhotoPreviewViewer extends StatefulWidget {
  const PhotoPreviewViewer({
    super.key,
    required this.photos,
    this.initialIndex = 0,
    required this.onPageChanged,
  });

  final List<Photo> photos;
  final int initialIndex;
  final ValueChanged<int> onPageChanged;

  @override
  State<PhotoPreviewViewer> createState() => _PhotoPreviewViewerState();
}

class _PhotoPreviewViewerState extends State<PhotoPreviewViewer> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photos.isEmpty) {
      return const Center(child: Text('No photos to display'));
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.photos.length,
      onPageChanged: widget.onPageChanged,
      itemBuilder: (context, index) {
        final photo = widget.photos[index];
        return InteractiveViewer(
          minScale: 1.0,
          maxScale: 4.0,
          clipBehavior: Clip.none,
          child: Center(
            child: Image.file(
              File(photo.path),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFFFFE2CC),
                padding: const EdgeInsets.all(24.0),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image_rounded, size: 56, color: Color(0xFFB94E2D)),
                    SizedBox(height: 12),
                    Text('Unable to display photo', style: TextStyle(color: Color(0xFF806A60))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

