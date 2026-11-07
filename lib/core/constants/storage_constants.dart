class StorageConstants {
  StorageConstants._();

  // Storage Format Versioning
  static const int storageFormatVersion = 1;
  static const String appDirectoryName = 'Lifora';

  // Folder Names
  static const String memoriesFolder = 'memories';
  static const String thumbnailsFolder = 'thumbnails';
  static const String exportsFolder = 'exports';
  static const String audioFolder = 'audio';
  static const String tempFolder = 'temp';

  // File Names
  static const String manifestFileName = 'manifest.json';
  static const String metadataFileName = 'memory.json';
  static const String appSettingsFileName = 'settings.json';
  static const String backupIndexFileName = 'backup_index.json';

  // File Extensions
  static const String jsonExtension = '.json';
  static const String zipExtension = '.zip';
  static const String jpgExtension = '.jpg';
  static const String pngExtension = '.png';
  static const String webpExtension = '.webp';

  // Storage Access Framework Preference Keys
  static const String safTreeUriKey = 'lifora_saf_tree_uri';
  static const String isStorageSetupCompleteKey =
      'lifora_storage_setup_complete';
}
