enum StorageStatus {
  notSelected,
  connected,
  permissionRevoked,
  unavailable,
  error;

  String get displayName {
    return switch (this) {
      StorageStatus.notSelected => 'Storage Not Selected',
      StorageStatus.connected => 'Connected',
      StorageStatus.permissionRevoked => 'Permission Revoked',
      StorageStatus.unavailable => 'Storage Unavailable',
      StorageStatus.error => 'Storage Error',
    };
  }

  bool get isReady => this == StorageStatus.connected;
}
