import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/enums/memory_category.dart';
import '../../../../shared/enums/memory_sort_type.dart';
import '../../../photos/presentation/providers/photo_gallery_provider.dart';
import '../../../storage/presentation/providers/storage_provider.dart';
import '../../data/datasources/memory_index_datasource.dart';
import '../../data/datasources/memory_json_datasource.dart';
import '../../data/datasources/memory_local_datasource.dart';
import '../../data/repositories/memory_repository_impl.dart';
import '../../domain/entities/memory.dart';
import '../../domain/repositories/memory_repository.dart';
import '../../domain/usecases/create_memory.dart';
import '../../domain/usecases/delete_memory.dart';
import '../../domain/usecases/get_all_memories.dart';
import '../../domain/usecases/get_memories_by_category.dart';
import '../../domain/usecases/get_memories_by_date.dart';
import '../../domain/usecases/get_memory_by_id.dart';
import '../../domain/usecases/get_memory_statistics.dart';
import '../../domain/usecases/get_recent_memories.dart';
import '../../domain/usecases/toggle_memory_favorite.dart';
import '../../domain/usecases/update_memory.dart';

// Data Sources
final memoryLocalDataSourceProvider = Provider<MemoryLocalDataSource>((ref) {
  return MemoryLocalDataSourceImpl();
});

final memoryJsonDataSourceProvider = Provider<MemoryJsonDataSource>((ref) {
  return MemoryJsonDataSourceImpl(
    safDataSource: ref.watch(safStorageDataSourceProvider),
    preferencesDataSource: ref.watch(storagePreferencesDataSourceProvider),
    manifestDataSource: ref.watch(storageManifestDataSourceProvider),
  );
});

final memoryIndexDataSourceProvider = Provider<MemoryIndexDataSource>((ref) {
  return MemoryIndexDataSourceImpl();
});

// Repository
final memoryRepositoryProvider = Provider<MemoryRepository>((ref) {
  return MemoryRepositoryImpl(
    localDataSource: ref.watch(memoryLocalDataSourceProvider),
    jsonDataSource: ref.watch(memoryJsonDataSourceProvider),
    indexDataSource: ref.watch(memoryIndexDataSourceProvider),
    preferencesDataSource: ref.watch(storagePreferencesDataSourceProvider),
    manifestDataSource: ref.watch(storageManifestDataSourceProvider),
    photoStorageDataSource: ref.watch(photoStorageDataSourceProvider),
  );
});

// Use Cases
final createMemoryUseCaseProvider = Provider<CreateMemory>((ref) {
  return CreateMemory(ref.watch(memoryRepositoryProvider));
});

final updateMemoryUseCaseProvider = Provider<UpdateMemory>((ref) {
  return UpdateMemory(ref.watch(memoryRepositoryProvider));
});

final deleteMemoryUseCaseProvider = Provider<DeleteMemory>((ref) {
  return DeleteMemory(ref.watch(memoryRepositoryProvider));
});

final getAllMemoriesUseCaseProvider = Provider<GetAllMemories>((ref) {
  return GetAllMemories(ref.watch(memoryRepositoryProvider));
});

final getMemoryByIdUseCaseProvider = Provider<GetMemoryById>((ref) {
  return GetMemoryById(ref.watch(memoryRepositoryProvider));
});

final getRecentMemoriesMemoriesUseCaseProvider = Provider<GetRecentMemories>((
  ref,
) {
  return GetRecentMemories(ref.watch(memoryRepositoryProvider));
});

final getMemoriesByDateUseCaseProvider = Provider<GetMemoriesByDate>((ref) {
  return GetMemoriesByDate(ref.watch(memoryRepositoryProvider));
});

final getMemoriesByCategoryUseCaseProvider = Provider<GetMemoriesByCategory>((
  ref,
) {
  return GetMemoriesByCategory(ref.watch(memoryRepositoryProvider));
});

final toggleMemoryFavoriteUseCaseProvider = Provider<ToggleMemoryFavorite>((
  ref,
) {
  return ToggleMemoryFavorite(ref.watch(memoryRepositoryProvider));
});

final getMemoryStatisticsMemoriesUseCaseProvider =
    Provider<GetMemoryStatistics>((ref) {
      return GetMemoryStatistics(ref.watch(memoryRepositoryProvider));
    });

// Memory List Notifier
class MemoryListNotifier extends StateNotifier<AsyncValue<List<Memory>>> {
  MemoryListNotifier({
    required this.getAllMemories,
    required this.createMemoryUseCase,
    required this.updateMemoryUseCase,
    required this.deleteMemoryUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(const AsyncValue.loading()) {
    loadMemories();
  }

  final GetAllMemories getAllMemories;
  final CreateMemory createMemoryUseCase;
  final UpdateMemory updateMemoryUseCase;
  final DeleteMemory deleteMemoryUseCase;
  final ToggleMemoryFavorite toggleFavoriteUseCase;

  Future<void> loadMemories({
    MemoryCategory? category,
    MemorySortType sortType = MemorySortType.newest,
    bool? isFavorite,
    String? query,
  }) async {
    state = const AsyncValue.loading();
    try {
      final memories = await getAllMemories(
        category: category,
        sortType: sortType,
        isFavorite: isFavorite,
        query: query,
      );
      state = AsyncValue.data(memories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await loadMemories();
  }

  Future<Memory> create(Memory memory, {List<String>? newPhotoPaths}) async {
    final created = await createMemoryUseCase(
      memory,
      newPhotoPaths: newPhotoPaths,
    );
    await refresh();
    return created;
  }

  Future<Memory> update(
    Memory memory, {
    List<String>? newPhotoPaths,
    List<String>? removedPhotoIds,
  }) async {
    final updated = await updateMemoryUseCase(
      memory,
      newPhotoPaths: newPhotoPaths,
      removedPhotoIds: removedPhotoIds,
    );
    await refresh();
    return updated;
  }

  Future<void> delete(String id) async {
    await deleteMemoryUseCase(id);
    await refresh();
  }

  Future<void> toggleFavorite(String id) async {
    await toggleFavoriteUseCase(id);
    await refresh();
  }
}

final memoryListNotifierProvider =
    StateNotifierProvider<MemoryListNotifier, AsyncValue<List<Memory>>>((ref) {
      return MemoryListNotifier(
        getAllMemories: ref.watch(getAllMemoriesUseCaseProvider),
        createMemoryUseCase: ref.watch(createMemoryUseCaseProvider),
        updateMemoryUseCase: ref.watch(updateMemoryUseCaseProvider),
        deleteMemoryUseCase: ref.watch(deleteMemoryUseCaseProvider),
        toggleFavoriteUseCase: ref.watch(toggleMemoryFavoriteUseCaseProvider),
      );
    });
