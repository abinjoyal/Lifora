import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifora/features/home/data/datasources/home_local_datasource.dart';
import 'package:lifora/features/home/data/repositories/home_repository_impl.dart';
import 'package:lifora/features/home/domain/entities/home_summary.dart';
import 'package:lifora/features/home/domain/repositories/home_repository.dart';
import 'package:lifora/features/home/domain/usecases/get_home_summary.dart';
import 'package:lifora/features/home/domain/usecases/get_memory_statistics.dart';
import 'package:lifora/features/home/domain/usecases/get_recent_memories.dart';
import 'package:lifora/features/storage/presentation/providers/storage_provider.dart';

// Data Source Provider
final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSourceImpl(
    preferencesDataSource: ref.watch(storagePreferencesDataSourceProvider),
    manifestDataSource: ref.watch(storageManifestDataSourceProvider),
  );
});

// Repository Provider
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    localDataSource: ref.watch(homeLocalDataSourceProvider),
  );
});

// Use Case Providers
final getHomeSummaryUseCaseProvider = Provider<GetHomeSummary>((ref) {
  return GetHomeSummary(ref.watch(homeRepositoryProvider));
});

final getRecentMemoriesUseCaseProvider = Provider<GetRecentMemories>((ref) {
  return GetRecentMemories(ref.watch(homeRepositoryProvider));
});

final getMemoryStatisticsUseCaseProvider = Provider<GetMemoryStatistics>((ref) {
  return GetMemoryStatistics(ref.watch(homeRepositoryProvider));
});

// Home Notifier managing Dashboard State
class HomeNotifier extends StateNotifier<AsyncValue<HomeSummary>> {
  HomeNotifier({required this.getHomeSummary})
    : super(const AsyncValue.loading()) {
    loadHomeData();
  }

  final GetHomeSummary getHomeSummary;

  Future<void> loadHomeData() async {
    state = const AsyncValue.loading();
    try {
      final summary = await getHomeSummary();
      state = AsyncValue.data(summary);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    try {
      final summary = await getHomeSummary();
      state = AsyncValue.data(summary);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final homeNotifierProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<HomeSummary>>((ref) {
      return HomeNotifier(
        getHomeSummary: ref.watch(getHomeSummaryUseCaseProvider),
      );
    });
