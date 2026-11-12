import 'dart:convert';
import '../../../memories/domain/repositories/memory_repository.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required this.localDataSource,
    required this.memoryRepository,
  });

  final SettingsLocalDataSource localDataSource;
  final MemoryRepository memoryRepository;

  @override
  Future<AppSettings> getSettings() {
    return localDataSource.getSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return localDataSource.saveSettings(settings);
  }

  @override
  Future<void> resetSettings() {
    return localDataSource.resetSettings();
  }

  @override
  Future<String> exportMemoriesJson() async {
    final memories = await memoryRepository.getAllMemories();

    final exportData = {
      'app': 'Lifora',
      'schemaVersion': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'totalMemories': memories.length,
      'memories': memories.map((m) {
        return {
          'id': m.id,
          'title': m.title,
          'description': m.description,
          'category': m.category.name,
          'date': m.date.toIso8601String(),
          'createdAt': m.createdAt.toIso8601String(),
          'updatedAt': m.updatedAt.toIso8601String(),
          'isFavorite': m.isFavorite,
          'tags': m.tags,
          'location': m.location != null
              ? {
                  'name': m.location!.name,
                  'address': m.location!.address,
                  'latitude': m.location!.latitude,
                  'longitude': m.location!.longitude,
                  'source': m.location!.source,
                }
              : null,
          'photosCount': m.photos.length,
          'photos': m.photos.map((p) {
            return {
              'id': p.id,
              'fileName': p.fileName,
              'originalFileName': p.originalFileName,
              'mimeType': p.mimeType,
              'addedAt': p.addedAt.toIso8601String(),
            };
          }).toList(),
        };
      }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }
}

