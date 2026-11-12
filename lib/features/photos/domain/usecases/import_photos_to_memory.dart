import 'package:lifora/features/memories/domain/entities/memory_photo.dart';
import '../repositories/photo_repository.dart';

class ImportPhotosToMemory {
  ImportPhotosToMemory(this._repository);

  final PhotoRepository _repository;

  Future<List<MemoryPhoto>> call({
    required String memoryId,
    required int year,
    required List<String> sourcePaths,
    String? coverSourcePath,
  }) {
    return _repository.importPhotosToMemory(
      memoryId: memoryId,
      year: year,
      sourcePaths: sourcePaths,
      coverSourcePath: coverSourcePath,
    );
  }
}
