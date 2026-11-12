import 'package:flutter/services.dart';
import '../models/photo_album_model.dart';
import '../models/photo_model.dart';

abstract class PhotoGalleryDataSource {
  Future<bool> checkPermission();
  Future<List<PhotoAlbumModel>> getPhotoAlbums();
  Future<List<PhotoModel>> getGalleryPhotos({String? albumId, int limit = 300});
  Future<List<String>> openPhotoPicker();
  Future<String?> capturePhoto();
}

class PhotoGalleryDataSourceImpl implements PhotoGalleryDataSource {
  PhotoGalleryDataSourceImpl({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.lifora.app/photos');

  final MethodChannel _channel;

  @override
  Future<bool> checkPermission() async {
    try {
      final bool? isGranted =
          await _channel.invokeMethod<bool>('checkPhotoPermission');
      return isGranted ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<PhotoAlbumModel>> getPhotoAlbums() async {
    try {
      final List<dynamic>? result =
          await _channel.invokeMethod<List<dynamic>>('getPhotoAlbums');
      if (result == null) return [];
      return result
          .map((item) => PhotoAlbumModel.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<PhotoModel>> getGalleryPhotos({String? albumId, int limit = 300}) async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod<List<dynamic>>(
        'getGalleryPhotos',
        {'albumId': albumId, 'limit': limit},
      );
      if (result == null) return [];
      return result
          .map((item) => PhotoModel.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<String>> openPhotoPicker() async {
    try {
      final List<dynamic>? result =
          await _channel.invokeMethod<List<dynamic>>('openPhotoPicker');
      if (result == null) return [];
      return result.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<String?> capturePhoto() async {
    try {
      final String? path = await _channel.invokeMethod<String>('capturePhoto');
      return path;
    } catch (_) {
      return null;
    }
  }
}

