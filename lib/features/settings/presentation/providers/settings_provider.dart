import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifora/core/theme/app_theme_provider.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/export_memories_data.dart';
import '../../domain/usecases/get_app_settings.dart';
import '../../domain/usecases/reset_app_settings.dart';
import '../../domain/usecases/save_app_settings.dart';

final settingsLocalDataSourceProvider =
    Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSourceImpl();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final local = ref.watch(settingsLocalDataSourceProvider);
  final memoryRepo = ref.watch(memoryRepositoryProvider);
  return SettingsRepositoryImpl(
    localDataSource: local,
    memoryRepository: memoryRepo,
  );
});

final getAppSettingsUseCaseProvider = Provider<GetAppSettings>((ref) {
  return GetAppSettings(ref.watch(settingsRepositoryProvider));
});

final saveAppSettingsUseCaseProvider = Provider<SaveAppSettings>((ref) {
  return SaveAppSettings(ref.watch(settingsRepositoryProvider));
});

final resetAppSettingsUseCaseProvider = Provider<ResetAppSettings>((ref) {
  return ResetAppSettings(ref.watch(settingsRepositoryProvider));
});

final exportMemoriesDataUseCaseProvider = Provider<ExportMemoriesData>((ref) {
  return ExportMemoriesData(ref.watch(settingsRepositoryProvider));
});

class SettingsState {
  const SettingsState({
    required this.settings,
    this.isLoading = false,
    this.isExporting = false,
    this.exportResult,
    this.errorMessage,
  });

  final AppSettings settings;
  final bool isLoading;
  final bool isExporting;
  final String? exportResult;
  final String? errorMessage;

  SettingsState copyWith({
    AppSettings? settings,
    bool? isLoading,
    bool? isExporting,
    String? exportResult,
    String? errorMessage,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isExporting: isExporting ?? this.isExporting,
      exportResult: exportResult,
      errorMessage: errorMessage,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier({
    required this.getSettings,
    required this.saveSettings,
    required this.resetSettingsUseCase,
    required this.exportMemories,
    required this.ref,
  }) : super(
          SettingsState(
            settings: AppSettings(updatedAt: DateTime.now()),
            isLoading: true,
          ),
        ) {
    loadSettings();
  }

  final GetAppSettings getSettings;
  final SaveAppSettings saveSettings;
  final ResetAppSettings resetSettingsUseCase;
  final ExportMemoriesData exportMemories;
  final Ref ref;

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final loaded = await getSettings();
      // Apply theme to global themeModeProvider
      ref.read(themeModeProvider.notifier).setThemeMode(loaded.themeMode);

      state = state.copyWith(
        settings: loaded,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    ref.read(themeModeProvider.notifier).setThemeMode(mode);

    final updated = state.settings.copyWith(
      themeMode: mode,
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(settings: updated);
    await saveSettings(updated);
  }

  Future<void> setLanguage(String code) async {
    final updated = state.settings.copyWith(
      languageCode: code,
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(settings: updated);
    await saveSettings(updated);
  }

  Future<void> setReduceAnimations(bool reduce) async {
    final updated = state.settings.copyWith(
      reduceAnimations: reduce,
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(settings: updated);
    await saveSettings(updated);
  }

  Future<void> setCompactLayout(bool compact) async {
    final updated = state.settings.copyWith(
      compactLayout: compact,
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(settings: updated);
    await saveSettings(updated);
  }

  Future<void> resetAllSettings() async {
    state = state.copyWith(isLoading: true);

    try {
      await resetSettingsUseCase();
      final fresh = await getSettings();
      ref.read(themeModeProvider.notifier).setThemeMode(fresh.themeMode);

      state = state.copyWith(
        settings: fresh,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<String?> exportData() async {
    state = state.copyWith(isExporting: true, errorMessage: null);

    try {
      final jsonOutput = await exportMemories();
      state = state.copyWith(
        isExporting: false,
        exportResult: jsonOutput,
        errorMessage: null,
      );
      return jsonOutput;
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final getSet = ref.watch(getAppSettingsUseCaseProvider);
  final saveSet = ref.watch(saveAppSettingsUseCaseProvider);
  final resetSet = ref.watch(resetAppSettingsUseCaseProvider);
  final exportData = ref.watch(exportMemoriesDataUseCaseProvider);

  return SettingsNotifier(
    getSettings: getSet,
    saveSettings: saveSet,
    resetSettingsUseCase: resetSet,
    exportMemories: exportData,
    ref: ref,
  );
});

