import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/platform_channel_service.dart';
import '../../../../shared/enums/storage_status.dart';
import '../../data/datasources/saf_storage_datasource.dart';
import '../../data/datasources/storage_local_datasource.dart';
import '../../data/datasources/storage_manifest_datasource.dart';
import '../../data/datasources/storage_preferences_datasource.dart';
import '../../data/repositories/storage_repository_impl.dart';
import '../../domain/entities/storage_info.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/usecases/create_lifora_folder.dart';
import '../../domain/usecases/get_storage_status.dart';
import '../../domain/usecases/initialize_storage.dart';
import '../../domain/usecases/reconnect_storage.dart';
import '../../domain/usecases/select_existing_folder.dart';
import '../../domain/usecases/select_parent_folder.dart';
import '../../domain/usecases/verify_storage_access.dart';

// Data Source Providers
final safStorageDataSourceProvider = Provider<SafStorageDataSource>((ref) {
  final platformService = ref.watch(platformChannelServiceProvider);
  return SafStorageDataSourceImpl(platformChannelService: platformService);
});

final storagePreferencesDataSourceProvider =
    Provider<StoragePreferencesDataSource>((ref) {
      return StoragePreferencesDataSourceImpl();
    });

final storageManifestDataSourceProvider = Provider<StorageManifestDataSource>((
  ref,
) {
  final saf = ref.watch(safStorageDataSourceProvider);
  return StorageManifestDataSourceImpl(safDataSource: saf);
});

final storageLocalDataSourceProvider = Provider<StorageLocalDataSource>((ref) {
  return StorageLocalDataSourceImpl();
});

// Repository Provider
final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepositoryImpl(
    safDataSource: ref.watch(safStorageDataSourceProvider),
    preferencesDataSource: ref.watch(storagePreferencesDataSourceProvider),
    manifestDataSource: ref.watch(storageManifestDataSourceProvider),
    localDataSource: ref.watch(storageLocalDataSourceProvider),
  );
});

// Use Case Providers
final selectParentFolderUseCaseProvider = Provider<SelectParentFolder>((ref) {
  return SelectParentFolder(ref.watch(storageRepositoryProvider));
});

final createLiforaFolderUseCaseProvider = Provider<CreateLiforaFolder>((ref) {
  return CreateLiforaFolder(ref.watch(storageRepositoryProvider));
});

final selectExistingFolderUseCaseProvider = Provider<SelectExistingFolder>((
  ref,
) {
  return SelectExistingFolder(ref.watch(storageRepositoryProvider));
});

final initializeStorageUseCaseProvider = Provider<InitializeStorage>((ref) {
  return InitializeStorage(ref.watch(storageRepositoryProvider));
});

final verifyStorageAccessUseCaseProvider = Provider<VerifyStorageAccess>((ref) {
  return VerifyStorageAccess(ref.watch(storageRepositoryProvider));
});

final reconnectStorageUseCaseProvider = Provider<ReconnectStorage>((ref) {
  return ReconnectStorage(ref.watch(storageRepositoryProvider));
});

final getStorageStatusUseCaseProvider = Provider<GetStorageStatus>((ref) {
  return GetStorageStatus(ref.watch(storageRepositoryProvider));
});

// Presentation State
class StorageState {
  const StorageState({
    this.status = StorageStatus.notSelected,
    this.storageInfo,
    this.isProcessing = false,
    this.loadingMessage,
    this.errorMessage,
  });

  final StorageStatus status;
  final StorageInfo? storageInfo;
  final bool isProcessing;
  final String? loadingMessage;
  final String? errorMessage;

  bool get isConnected =>
      status == StorageStatus.connected && storageInfo != null;

  StorageState copyWith({
    StorageStatus? status,
    StorageInfo? storageInfo,
    bool? isProcessing,
    String? loadingMessage,
    String? errorMessage,
  }) {
    return StorageState(
      status: status ?? this.status,
      storageInfo: storageInfo ?? this.storageInfo,
      isProcessing: isProcessing ?? this.isProcessing,
      loadingMessage: loadingMessage,
      errorMessage: errorMessage,
    );
  }
}

class StorageNotifier extends StateNotifier<StorageState> {
  StorageNotifier({
    required this.selectParentFolder,
    required this.createLiforaFolder,
    required this.selectExistingFolder,
    required this.reconnectStorage,
    required this.getStorageStatus,
  }) : super(const StorageState()) {
    checkInitialStorage();
  }

  final SelectParentFolder selectParentFolder;
  final CreateLiforaFolder createLiforaFolder;
  final SelectExistingFolder selectExistingFolder;
  final ReconnectStorage reconnectStorage;
  final GetStorageStatus getStorageStatus;

  Future<void> checkInitialStorage() async {
    try {
      final current = await getStorageStatus();
      if (current != null) {
        state = state.copyWith(
          status: StorageStatus.connected,
          storageInfo: current,
        );
      }
    } catch (_) {}
  }

  /// Option A: Creates new "Lifora Memories" subfolder inside selected parent
  Future<bool> handleCreateNewFolder() async {
    if (state.isProcessing) return false;

    state = state.copyWith(
      isProcessing: true,
      loadingMessage: 'Opening Android folder picker...',
      errorMessage: null,
    );

    try {
      final parentUri = await selectParentFolder();
      if (parentUri == null) {
        // User cancelled picker
        state = state.copyWith(isProcessing: false, loadingMessage: null);
        return false;
      }

      state = state.copyWith(
        loadingMessage: 'Creating Lifora Memories folder...',
      );
      final info = await createLiforaFolder(parentUri);

      state = state.copyWith(
        isProcessing: false,
        status: StorageStatus.connected,
        storageInfo: info,
        loadingMessage: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        status: StorageStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        loadingMessage: null,
      );
      return false;
    }
  }

  /// Option B: Chooses existing folder or reconnects
  Future<bool> handleChooseExistingFolder() async {
    if (state.isProcessing) return false;

    state = state.copyWith(
      isProcessing: true,
      loadingMessage: 'Opening Android folder picker...',
      errorMessage: null,
    );

    try {
      final info = await selectExistingFolder();
      if (info == null) {
        // User cancelled picker
        state = state.copyWith(isProcessing: false, loadingMessage: null);
        return false;
      }

      state = state.copyWith(
        isProcessing: false,
        status: StorageStatus.connected,
        storageInfo: info,
        loadingMessage: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        status: StorageStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        loadingMessage: null,
      );
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

final storageNotifierProvider =
    StateNotifierProvider<StorageNotifier, StorageState>((ref) {
      return StorageNotifier(
        selectParentFolder: ref.watch(selectParentFolderUseCaseProvider),
        createLiforaFolder: ref.watch(createLiforaFolderUseCaseProvider),
        selectExistingFolder: ref.watch(selectExistingFolderUseCaseProvider),
        reconnectStorage: ref.watch(reconnectStorageUseCaseProvider),
        getStorageStatus: ref.watch(getStorageStatusUseCaseProvider),
      );
    });
