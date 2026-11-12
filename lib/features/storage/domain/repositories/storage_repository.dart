import '../entities/storage_info.dart';

abstract class StorageRepository {
  /// Launches the SAF directory picker to select a parent directory.
  Future<String?> selectParentFolder();

  /// Creates a dedicated "Lifora Memories" subfolder inside parent directory,
  /// initializes the required structure, manifest, and settings.
  Future<StorageInfo> createLiforaFolder(String parentTreeUri);

  /// Selects an existing directory via SAF and inspects for an existing Lifora manifest.
  Future<StorageInfo?> selectExistingFolder();

  /// Initializes the Lifora Memories structure (Memories/, Thumbnails/, Exports/, manifest.json, settings.json).
  Future<StorageInfo> initializeStorage(String targetTreeUri);

  /// Verifies read and write permissions on the given folder tree.
  Future<bool> verifyStorageAccess(String treeUri);

  /// Reconnects to an existing Lifora folder after app reinstall, validating manifest integrity.
  Future<StorageInfo> reconnectStorage(String treeUri);

  /// Retrieves currently configured storage info, if any.
  Future<StorageInfo?> getCurrentStorage();

  /// Releases persistent permissions and resets local storage preferences.
  Future<void> disconnectStorage();
}
