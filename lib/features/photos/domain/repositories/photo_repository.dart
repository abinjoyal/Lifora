import 'package:lifora/features/memories/domain/entities/memory_photo.dart';
import '../entities/photo.dart';
import '../entities/photo_album.dart';

abstract class PhotoRepository {
  /// Checks whether gallery read permission is currently granted.
  Future<bool> checkPermission();

  /// Retrieves list of device photo albums.
  Future<List<PhotoAlbum>> getPhotoAlbums();

  /// Retrieves photos from gallery, optionally filtered by album.
  Future<List<Photo>> getGalleryPhotos({String? albumId, int limit = 300});

  /// Opens the modern Android Photo Picker and returns selected photo paths/URIs.
  Future<List<String>> openPhotoPicker();

  /// Launches device camera to capture a new photo and returns the file path.
  Future<String?> capturePhoto();

  /// Imports and copies selected photo paths into Lifora SAF storage under:
  /// `Lifora Memories/Memories/{year}/{memoryId}/`
  /// and generates corresponding thumbnails under:
  /// `Lifora Memories/Thumbnails/`
  /// Returns the imported [MemoryPhoto] entities.
  Future<List<MemoryPhoto>> importPhotosToMemory({
    required String memoryId,
    required int year,
    required List<String> sourcePaths,
    String? coverSourcePath,
  });
}
