import '../models/storage_info_model.dart';

abstract class StorageLocalDataSource {
  StorageInfoModel? getCachedStorageInfo();
  void cacheStorageInfo(StorageInfoModel info);
  void clearCache();
}

class StorageLocalDataSourceImpl implements StorageLocalDataSource {
  StorageLocalDataSourceImpl();

  static StorageInfoModel? _cachedInfo;

  @override
  StorageInfoModel? getCachedStorageInfo() => _cachedInfo;

  @override
  void cacheStorageInfo(StorageInfoModel info) {
    _cachedInfo = info;
  }

  @override
  void clearCache() {
    _cachedInfo = null;
  }
}
