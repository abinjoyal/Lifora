import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/photo_album.dart';
import 'photo_gallery_provider.dart';

final selectedAlbumProvider = StateProvider<PhotoAlbum?>((ref) => null);

final photoAlbumsProvider = FutureProvider<List<PhotoAlbum>>((ref) async {
  final getPhotoAlbums = ref.watch(getPhotoAlbumsUseCaseProvider);
  return getPhotoAlbums();
});

