import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/platform_channel_service.dart';
import '../../../storage/presentation/providers/storage_provider.dart';
import '../../data/datasources/photo_file_datasource.dart';
import '../../data/datasources/photo_gallery_datasource.dart';
import '../../data/datasources/photo_storage_datasource.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../domain/usecases/capture_photo.dart';
import '../../domain/usecases/get_gallery_photos.dart';
import '../../domain/usecases/get_photo_albums.dart';
import '../../domain/usecases/get_photo_details.dart';
import '../../domain/usecases/import_photos_to_memory.dart';
import '../../domain/usecases/remove_selected_photo.dart';
import '../../domain/usecases/select_photos.dart';
import '../../domain/usecases/set_cover_photo.dart';
import 'photo_album_provider.dart';

// Data sources
final photoGalleryDataSourceProvider = Provider<PhotoGalleryDataSource>((ref) {
  return PhotoGalleryDataSourceImpl();
});

final photoFileDataSourceProvider = Provider<PhotoFileDataSource>((ref) {
  return PhotoFileDataSourceImpl();
});

final photoStorageDataSourceProvider = Provider<PhotoStorageDataSource>((ref) {
  return PhotoStorageDataSourceImpl(
    safDataSource: ref.watch(safStorageDataSourceProvider),
    preferencesDataSource: ref.watch(storagePreferencesDataSourceProvider),
    platformChannelService: ref.watch(platformChannelServiceProvider),
  );
});

// Repository
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepositoryImpl(
    galleryDataSource: ref.watch(photoGalleryDataSourceProvider),
    fileDataSource: ref.watch(photoFileDataSourceProvider),
    storageDataSource: ref.watch(photoStorageDataSourceProvider),
  );
});

// Use cases
final getGalleryPhotosUseCaseProvider = Provider<GetGalleryPhotos>((ref) {
  return GetGalleryPhotos(ref.watch(photoRepositoryProvider));
});

final getPhotoAlbumsUseCaseProvider = Provider<GetPhotoAlbums>((ref) {
  return GetPhotoAlbums(ref.watch(photoRepositoryProvider));
});

final selectPhotosUseCaseProvider = Provider<SelectPhotos>((ref) {
  return SelectPhotos();
});

final removeSelectedPhotoUseCaseProvider = Provider<RemoveSelectedPhoto>((ref) {
  return RemoveSelectedPhoto();
});

final setCoverPhotoUseCaseProvider = Provider<SetCoverPhoto>((ref) {
  return SetCoverPhoto();
});

final importPhotosToMemoryUseCaseProvider = Provider<ImportPhotosToMemory>((ref) {
  return ImportPhotosToMemory(ref.watch(photoRepositoryProvider));
});

final capturePhotoUseCaseProvider = Provider<CapturePhoto>((ref) {
  return CapturePhoto(ref.watch(photoRepositoryProvider));
});

final getPhotoDetailsUseCaseProvider = Provider<GetPhotoDetails>((ref) {
  return GetPhotoDetails();
});

// Permission state
final photoPermissionProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(photoRepositoryProvider);
  return repo.checkPermission();
});

// Gallery photos notifier
class GalleryPhotosNotifier extends AsyncNotifier<List<Photo>> {
  @override
  Future<List<Photo>> build() async {
    final selectedAlbum = ref.watch(selectedAlbumProvider);
    final getGalleryPhotos = ref.watch(getGalleryPhotosUseCaseProvider);
    return getGalleryPhotos(albumId: selectedAlbum?.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final selectedAlbum = ref.read(selectedAlbumProvider);
      final getGalleryPhotos = ref.read(getGalleryPhotosUseCaseProvider);
      return getGalleryPhotos(albumId: selectedAlbum?.id);
    });
  }
}

final galleryPhotosProvider =
    AsyncNotifierProvider<GalleryPhotosNotifier, List<Photo>>(() {
  return GalleryPhotosNotifier();
});

