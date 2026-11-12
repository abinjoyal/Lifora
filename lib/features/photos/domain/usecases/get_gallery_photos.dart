import '../entities/photo.dart';
import '../repositories/photo_repository.dart';

class GetGalleryPhotos {
  GetGalleryPhotos(this._repository);

  final PhotoRepository _repository;

  Future<List<Photo>> call({String? albumId, int limit = 300}) {
    return _repository.getGalleryPhotos(albumId: albumId, limit: limit);
  }
}

