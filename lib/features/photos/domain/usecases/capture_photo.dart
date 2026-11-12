import '../repositories/photo_repository.dart';

class CapturePhoto {
  CapturePhoto(this._repository);

  final PhotoRepository _repository;

  Future<String?> call() {
    return _repository.capturePhoto();
  }
}

