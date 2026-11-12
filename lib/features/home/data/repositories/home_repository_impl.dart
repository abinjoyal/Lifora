import '../../domain/entities/home_summary.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.localDataSource});

  final HomeLocalDataSource localDataSource;

  @override
  Future<HomeSummary> getHomeSummary() => localDataSource.getHomeSummary();

  @override
  Future<List<HomeMemoryItem>> getRecentMemories({int limit = 5}) =>
      localDataSource.getRecentMemories(limit: limit);

  @override
  Future<Map<String, int>> getMemoryStatistics() =>
      localDataSource.getMemoryStatistics();
}
