import 'package:lifora/features/memories/domain/entities/memory_photo.dart';
import '../datasources/photo_file_datasource.dart';
import '../datasources/photo_gallery_datasource.dart';
import '../datasources/photo_storage_datasource.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/photo_album.dart';
import '../../domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({
    required this.galleryDataSource,
    required this.storageDataSource,
    this.fileDataSource,
  });

  final PhotoGalleryDataSource galleryDataSource;
  final PhotoStorageDataSource storageDataSource;
  final PhotoFileDataSource? fileDataSource;

  @override
  Future<bool> checkPermission() {
    return galleryDataSource.checkPermission();
  }

  @override
  Future<List<PhotoAlbum>> getPhotoAlbums() async {
    final models = await galleryDataSource.getPhotoAlbums();
    return models;
  }

  @override
  Future<List<Photo>> getGalleryPhotos({String? albumId, int limit = 300}) async {
    final models = await galleryDataSource.getGalleryPhotos(
      albumId: albumId,
      limit: limit,
    );
    return models;
  }

  @override
  Future<List<String>> openPhotoPicker() {
    return galleryDataSource.openPhotoPicker();
  }

  @override
  Future<String?> capturePhoto() {
    return galleryDataSource.capturePhoto();
  }

  @override
  Future<List<MemoryPhoto>> importPhotosToMemory({
    required String memoryId,
    required int year,
    required List<String> sourcePaths,
    String? coverSourcePath,
  }) async {
    final models = await storageDataSource.importPhotosToMemory(
      memoryId: memoryId,
      year: year,
      sourcePaths: sourcePaths,
      coverSourcePath: coverSourcePath,
    );
    return models;
  }
}
