import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/photo_album.dart';
import '../providers/photo_album_provider.dart';

class PhotoAlbumPage extends ConsumerWidget {
  const PhotoAlbumPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _titleColor = Color(0xFF38251F);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsAsync = ref.watch(photoAlbumsProvider);
    final selectedAlbum = ref.watch(selectedAlbumProvider);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Albums'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: albumsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(_primaryOrange),
            ),
          ),
          error: (e, _) => Center(
            child: Text('Failed to load albums: $e'),
          ),
          data: (albums) {
            // Include an "All Photos" virtual album
            final allPhotosAlbum = const PhotoAlbum(
              id: 'all',
              name: 'All Photos',
              photoCount: 0,
            );
            final allList = [allPhotosAlbum, ...albums];

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              itemCount: allList.length,
              separatorBuilder: (_, _) => const Divider(
                color: Color(0xFFEADBCE),
                height: 1.0,
              ),
              itemBuilder: (context, index) {
                final album = allList[index];
                final isSelected = (album.id == 'all' && selectedAlbum == null) ||
                    (selectedAlbum?.id == album.id);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  leading: _buildAlbumCover(album),
                  title: Text(
                    album.name,
                    style: TextStyle(
                      color: isSelected ? _primaryOrange : _titleColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                  subtitle: album.id != 'all'
                      ? Text(
                          '${album.photoCount} photos',
                          style: const TextStyle(
                            color: Color(0xFF806A60),
                            fontSize: 12.5,
                          ),
                        )
                      : null,
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded, color: _primaryOrange)
                      : const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.0,
                          color: Color(0xFF806A60),
                        ),
                  onTap: () {
                    ref.read(selectedAlbumProvider.notifier).state =
                        album.id == 'all' ? null : album;
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlbumCover(PhotoAlbum album) {
    if (album.coverPhotoPath != null) {
      return Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9.0),
          child: Image.file(
            File(album.coverPhotoPath!),
            fit: BoxFit.cover,
            cacheWidth: 120,
            cacheHeight: 120,
            errorBuilder: (_, _, _) => _buildPlaceholder(),
          ),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2CC),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Icon(
        Icons.photo_library_rounded,
        color: _primaryOrange,
        size: 24.0,
      ),
    );
  }
}

