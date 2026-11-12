import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/photo.dart';
import '../providers/photo_selection_provider.dart';
import '../widgets/photo_preview_viewer.dart';

class PhotoPreviewPage extends ConsumerStatefulWidget {
  const PhotoPreviewPage({
    super.key,
    required this.photos,
    this.initialIndex = 0,
  });

  final List<Photo> photos;
  final int initialIndex;

  @override
  ConsumerState<PhotoPreviewPage> createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends ConsumerState<PhotoPreviewPage> {
  late int _currentIndex;

  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final selectionState = ref.watch(photoSelectionProvider);
    final selectionNotifier = ref.read(photoSelectionProvider.notifier);

    if (widget.photos.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text('No photos', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final currentPhoto = widget.photos[_currentIndex];
    final isSelected = selectionState.isSelected(currentPhoto.id);
    final isCover = selectionState.isCover(currentPhoto.id);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${_currentIndex + 1} of ${widget.photos.length}',
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        actions: [
          // Select / Deselect toggle button
          IconButton(
            icon: Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? _primaryOrange : Colors.white,
              size: 26.0,
            ),
            tooltip: isSelected ? 'Deselect Photo' : 'Select Photo',
            onPressed: () => selectionNotifier.togglePhoto(currentPhoto),
          ),
        ],
      ),
      body: PhotoPreviewViewer(
        photos: widget.photos,
        initialIndex: widget.initialIndex,
        onPageChanged: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
      ),
      bottomNavigationBar: isSelected
          ? Container(
              color: Colors.black.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: isCover ? _primaryOrange : Colors.white,
                      ),
                      icon: Icon(
                        isCover ? Icons.star_rounded : Icons.star_border_rounded,
                        color: isCover ? _primaryOrange : Colors.white70,
                      ),
                      label: Text(
                        isCover ? 'Cover Photo' : 'Set as Cover',
                        style: TextStyle(
                          color: isCover ? _primaryOrange : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => selectionNotifier.setCoverPhoto(currentPhoto.id),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Done (${selectionState.count})'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

