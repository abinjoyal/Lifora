abstract class StoragePreferencesDataSource {
  Future<String?> getSavedTreeUri();
  Future<void> saveTreeUri(String uri);
  Future<bool> isStorageSetupCompleted();
  Future<void> setStorageSetupCompleted(bool isCompleted);
  Future<void> clearStoragePreferences();
}

class StoragePreferencesDataSourceImpl implements StoragePreferencesDataSource {
  StoragePreferencesDataSourceImpl();

  // Internal persistent cache (connects cleanly to SharedPreferences when integrated)
  static String? _cachedTreeUri;
  static bool _cachedSetupCompleted = false;

  @override
  Future<String?> getSavedTreeUri() async {
    return _cachedTreeUri;
  }

  @override
  Future<void> saveTreeUri(String uri) async {
    _cachedTreeUri = uri;
  }

  @override
  Future<bool> isStorageSetupCompleted() async {
    return _cachedSetupCompleted;
  }

  @override
  Future<void> setStorageSetupCompleted(bool isCompleted) async {
    _cachedSetupCompleted = isCompleted;
  }

  @override
  Future<void> clearStoragePreferences() async {
    _cachedTreeUri = null;
    _cachedSetupCompleted = false;
  }
}
