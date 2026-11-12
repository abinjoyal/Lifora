import 'package:lifora/features/storage/data/datasources/storage_manifest_datasource.dart';
import 'package:lifora/features/storage/data/datasources/storage_preferences_datasource.dart';

import '../../../photos/data/datasources/photo_storage_datasource.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_photo.dart';
import '../../domain/repositories/memory_repository.dart';
import '../datasources/memory_index_datasource.dart';
import '../datasources/memory_json_datasource.dart';
import '../datasources/memory_local_datasource.dart';
import '../models/memory_model.dart';
import '../models/memory_photo_model.dart';

class MemoryRepositoryImpl implements MemoryRepository {
  MemoryRepositoryImpl({
    required this.localDataSource,
    required this.jsonDataSource,
    required this.indexDataSource,
    required this.preferencesDataSource,
    required this.manifestDataSource,
    this.photoStorageDataSource,
  });

  final MemoryLocalDataSource localDataSource;
  final MemoryJsonDataSource jsonDataSource;
  final MemoryIndexDataSource indexDataSource;
  final StoragePreferencesDataSource preferencesDataSource;
  final StorageManifestDataSource manifestDataSource;
  final PhotoStorageDataSource? photoStorageDataSource;

  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    final treeUri = await preferencesDataSource.getSavedTreeUri();
    if (treeUri != null && treeUri.isNotEmpty) {
      final manifest = await manifestDataSource.readManifest(treeUri);
      if (manifest != null) {
        final List<MemoryModel> loaded = [];
        for (final mEntry in manifest.memories) {
          final id = mEntry['id'] as String?;
          final dateStr = mEntry['date'] as String?;
          if (id != null && dateStr != null) {
            final date =
                DateTime.tryParse(dateStr)?.toLocal() ?? DateTime.now();
            final fullMemory = await jsonDataSource.readMemoryJson(
              id,
              date.year,
            );
            if (fullMemory != null) {
              loaded.add(fullMemory);
            } else {
              // Fallback to manifest entry if subfolder is pending
              loaded.add(MemoryModel.fromJson(mEntry));
            }
          }
        }
        localDataSource.cacheMemories(loaded);
        await indexDataSource.rebuildIndex(loaded);
      }
    }
    _isInitialized = true;
  }

  @override
  Future<List<Memory>> getAllMemories({
    MemoryCategory? category,
    MemorySortType sortType = MemorySortType.newest,
    bool? isFavorite,
    String? query,
  }) async {
    await _ensureInitialized();
    return indexDataSource.queryMemories(
      category: category,
      sortType: sortType,
      isFavorite: isFavorite,
      query: query,
    );
  }

  @override
  Future<Memory?> getMemoryById(String id) async {
    await _ensureInitialized();
    final cached = localDataSource.getCachedMemory(id);
    if (cached != null) return cached;

    final memories = await getAllMemories();
    return memories.where((m) => m.id == id).firstOrNull;
  }

  @override
  Future<List<Memory>> getRecentMemories({int limit = 5}) async {
    await _ensureInitialized();
    final all = await indexDataSource.queryMemories(
      sortType: MemorySortType.newest,
    );
    return all.take(limit).toList();
  }

  @override
  Future<List<Memory>> getMemoriesByDate(DateTime date) async {
    await _ensureInitialized();
    return indexDataSource.queryMemories(date: date);
  }

  @override
  Future<List<Memory>> getMemoriesByCategory(MemoryCategory category) async {
    await _ensureInitialized();
    return indexDataSource.queryMemories(category: category);
  }

  @override
  Future<Memory> createMemory(
    Memory memory, {
    List<String>? newPhotoPaths,
  }) async {
    await _ensureInitialized();

    final List<MemoryPhoto> photos = List.from(memory.photos);

    // If new local photo paths were supplied from gallery/camera
    if (newPhotoPaths != null && newPhotoPaths.isNotEmpty) {
      if (photoStorageDataSource != null) {
        final imported = await photoStorageDataSource!.importPhotosToMemory(
          memoryId: memory.id,
          year: memory.date.year,
          sourcePaths: newPhotoPaths,
          coverSourcePath: memory.coverPhoto?.localPath,
        );
        photos.addAll(imported);
      } else {
        for (int i = 0; i < newPhotoPaths.length; i++) {
          final path = newPhotoPaths[i];
          final fileName =
              'photo_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          photos.add(
            MemoryPhotoModel(
              id: 'photo_${DateTime.now().millisecondsSinceEpoch}_$i',
              fileName: fileName,
              originalFileName: path.split('/').last,
              addedAt: DateTime.now().toUtc(),
              localPath: path,
            ),
          );
        }
      }
    }

    final coverId =
        memory.coverPhotoId ?? (photos.isNotEmpty ? photos.first.id : null);

    final model = MemoryModel(
      id: memory.id,
      title: memory.title,
      description: memory.description,
      category: memory.category,
      date: memory.date,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      photos: photos,
      coverPhotoId: coverId,
      location: memory.location,
      tags: memory.tags,
      isFavorite: memory.isFavorite,
    );

    // 1. Save portable JSON inside folder structure
    await jsonDataSource.saveMemoryJson(model);

    // 2. Cache in local data source and index
    localDataSource.upsertMemory(model);
    await indexDataSource.indexMemory(model);

    // 3. Update root manifest.json
    await jsonDataSource.updateManifest(localDataSource.getCachedMemories());

    return model;
  }

  @override
  Future<Memory> updateMemory(
    Memory memory, {
    List<String>? newPhotoPaths,
    List<String>? removedPhotoIds,
  }) async {
    await _ensureInitialized();

    var photos = List<MemoryPhoto>.from(memory.photos);

    // Remove deleted photos
    if (removedPhotoIds != null && removedPhotoIds.isNotEmpty) {
      photos.removeWhere((p) => removedPhotoIds.contains(p.id));
    }

    // Add newly picked photos
    if (newPhotoPaths != null && newPhotoPaths.isNotEmpty) {
      if (photoStorageDataSource != null) {
        final imported = await photoStorageDataSource!.importPhotosToMemory(
          memoryId: memory.id,
          year: memory.date.year,
          sourcePaths: newPhotoPaths,
          coverSourcePath: memory.coverPhoto?.localPath,
        );
        photos.addAll(imported);
      } else {
        for (int i = 0; i < newPhotoPaths.length; i++) {
          final path = newPhotoPaths[i];
          final fileName =
              'photo_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          photos.add(
            MemoryPhotoModel(
              id: 'photo_${DateTime.now().millisecondsSinceEpoch}_$i',
              fileName: fileName,
              originalFileName: path.split('/').last,
              addedAt: DateTime.now().toUtc(),
              localPath: path,
            ),
          );
        }
      }
    }

    final coverId = photos.any((p) => p.id == memory.coverPhotoId)
        ? memory.coverPhotoId
        : (photos.isNotEmpty ? photos.first.id : null);

    final model = MemoryModel(
      id: memory.id,
      title: memory.title,
      description: memory.description,
      category: memory.category,
      date: memory.date,
      createdAt: memory.createdAt,
      updatedAt: DateTime.now().toUtc(),
      photos: photos,
      coverPhotoId: coverId,
      location: memory.location,
      tags: memory.tags,
      isFavorite: memory.isFavorite,
    );

    await jsonDataSource.saveMemoryJson(model);
    localDataSource.upsertMemory(model);
    await indexDataSource.indexMemory(model);
    await jsonDataSource.updateManifest(localDataSource.getCachedMemories());

    return model;
  }

  @override
  Future<void> deleteMemory(String id) async {
    await _ensureInitialized();

    final memory = localDataSource.getCachedMemory(id);
    if (memory != null) {
      await jsonDataSource.deleteMemoryFolder(id, memory.date.year);
    }

    localDataSource.removeMemory(id);
    await indexDataSource.removeIndexedMemory(id);
    await jsonDataSource.updateManifest(localDataSource.getCachedMemories());
  }

  @override
  Future<Memory> toggleFavorite(String id) async {
    await _ensureInitialized();

    final current = await getMemoryById(id);
    if (current == null) {
      throw Exception('Memory $id not found');
    }

    final updated = current.copyWith(
      isFavorite: !current.isFavorite,
      updatedAt: DateTime.now().toUtc(),
    );

    return updateMemory(updated);
  }

  @override
  Future<Map<String, int>> getMemoryStatistics() async {
    await _ensureInitialized();
    final all = localDataSource.getCachedMemories();

    final total = all.length;
    final trips = all.where((m) => m.category == MemoryCategory.travel).length;
    final events = all
        .where(
          (m) =>
              m.category == MemoryCategory.celebration ||
              m.category == MemoryCategory.friends ||
              m.category == MemoryCategory.family,
        )
        .length;

    return {'total': total, 'trips': trips, 'events': events};
  }
}
