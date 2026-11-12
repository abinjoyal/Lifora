import '../entities/photo_album.dart';
import '../repositories/photo_repository.dart';

class GetPhotoAlbums {
  GetPhotoAlbums(this._repository);

  final PhotoRepository _repository;

  Future<List<PhotoAlbum>> call() {
    return _repository.getPhotoAlbums();
  }
}

