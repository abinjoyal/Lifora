import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../domain/entities/photo.dart';
import '../providers/photo_album_provider.dart';
import '../providers/photo_gallery_provider.dart';
import '../providers/photo_selection_provider.dart';
import '../widgets/photo_album_selector.dart';
import '../widgets/photo_empty_state.dart';
import '../widgets/photo_grid.dart';
import '../widgets/photo_permission_view.dart';
import '../widgets/photo_picker_header.dart';
import '../widgets/selected_photos_bar.dart';
import 'photo_preview_page.dart';

class PhotoPickerResult {
  const PhotoPickerResult({
    required this.photoPaths,
    this.coverPhotoPath,
  });

  final List<String> photoPaths;
  final String? coverPhotoPath;
}

class PhotoPickerPage extends ConsumerWidget {
  const PhotoPickerPage({super.key, this.maxLimit = 30});

  final int maxLimit;

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(galleryPhotosProvider);
    final selectionState = ref.watch(photoSelectionProvider);
    final selectionNotifier = ref.read(photoSelectionProvider.notifier);
    final selectedAlbum = ref.watch(selectedAlbumProvider);

    // Listen for status/limit messages
    ref.listen<PhotoSelectionState>(photoSelectionProvider, (prev, next) {
      if (next.statusMessage != null &&
          next.statusMessage != prev?.statusMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.statusMessage!),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF38251F),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            PhotoPickerHeader(
              selectedCount: selectionState.count,
              onBack: () => Navigator.pop(context),
              onDone: () => _finishSelection(context, selectionState),
            ),

            // Album selector & Camera shortcut bar
            PhotoAlbumSelector(
              selectedAlbum: selectedAlbum,
              onTap: () => context.push(RouteConstants.photoAlbumsPath),
              onCameraTap: () => _launchCamera(context, ref),
            ),

            // Main Content Area
            Expanded(
              child: photosAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
                  ),
                ),
                error: (e, _) => PhotoPermissionView(
                  onOpenSystemPicker: () => _openSystemPicker(ref),
                  onRequestPermission: () =>
                      ref.read(galleryPhotosProvider.notifier).refresh(),
                ),
                data: (photos) {
                  if (photos.isEmpty) {
                    return PhotoEmptyState(
                      message: selectedAlbum != null
                          ? 'No photos found in "${selectedAlbum.name}".'
                          : 'No photos accessible in device gallery.',
                      actionLabel: 'Open System Picker',
                      onAction: () => _openSystemPicker(ref),
                    );
                  }

                  return PhotoGrid(
                    photos: photos,
                    selectedPhotoIds: selectionState.selectedPhotos
                        .map((p) => p.id)
                        .toList(),
                    onTogglePhoto: (photo) =>
                        selectionNotifier.togglePhoto(photo),
                    onPreviewPhoto: (photo) => _previewPhotos(
                      context,
                      photos,
                      photos.indexOf(photo),
                    ),
                  );
                },
              ),
            ),

            // Bottom Selected Photos Bar
            SelectedPhotosBar(
              selectedPhotos: selectionState.selectedPhotos,
              coverPhotoId: selectionState.coverPhotoId,
              onRemovePhoto: (id) => selectionNotifier.removePhoto(id),
              onSetCoverPhoto: (id) => selectionNotifier.setCoverPhoto(id),
              onConfirm: () => _finishSelection(context, selectionState),
            ),
          ],
        ),
      ),
    );
  }

  void _finishSelection(
    BuildContext context,
    PhotoSelectionState selectionState,
  ) {
    if (selectionState.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final paths = selectionState.selectedPhotos.map((p) => p.path).toList();
    final coverPhoto = selectionState.selectedPhotos
        .where((p) => p.id == selectionState.coverPhotoId)
        .firstOrNull;
    final coverPath = coverPhoto?.path ?? paths.first;

    Navigator.pop(
      context,
      PhotoPickerResult(photoPaths: paths, coverPhotoPath: coverPath),
    );
  }

  Future<void> _launchCamera(BuildContext context, WidgetRef ref) async {
    final capturePhoto = ref.read(capturePhotoUseCaseProvider);
    final path = await capturePhoto();
    if (path != null && path.isNotEmpty) {
      ref.read(photoSelectionProvider.notifier).addRawPaths([path]);
    }
  }

  Future<void> _openSystemPicker(WidgetRef ref) async {
    final repo = ref.read(photoRepositoryProvider);
    final paths = await repo.openPhotoPicker();
    if (paths.isNotEmpty) {
      ref.read(photoSelectionProvider.notifier).addRawPaths(paths);
    }
  }

  void _previewPhotos(
    BuildContext context,
    List<Photo> photos,
    int initialIndex,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoPreviewPage(
          photos: photos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

