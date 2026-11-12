import 'dart:io';
import '../entities/photo.dart';

class GetPhotoDetails {
  Future<Photo> call(Photo photo) async {
    try {
      final file = File(photo.path);
      if (await file.exists()) {
        final length = await file.length();
        return photo.copyWith(size: length);
      }
    } catch (_) {}
    return photo;
  }
}

