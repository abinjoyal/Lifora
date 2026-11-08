sealed class AppFailure {
  const AppFailure({required this.message, required this.code, this.details});

  final String message;
  final String code;
  final Object? details;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppFailure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;

  @override
  String toString() => '$runtimeType(code: $code, message: $message)';
}

class StorageFailure extends AppFailure {
  const StorageFailure({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.details,
  });
}

class PermissionFailure extends AppFailure {
  const PermissionFailure({
    required super.message,
    super.code = 'PERMISSION_DENIED',
    super.details,
  });
}

class FileOperationFailure extends AppFailure {
  const FileOperationFailure({
    required super.message,
    super.code = 'FILE_OPERATION_ERROR',
    super.details,
  });
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure({
    required super.message,
    super.code = 'DATABASE_ERROR',
    super.details,
  });
}

class LocationFailure extends AppFailure {
  const LocationFailure({
    required super.message,
    super.code = 'LOCATION_ERROR',
    super.details,
  });
}

class NetworkFailure extends AppFailure {
  const NetworkFailure({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}

class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
  });
}

class UnknownFailure extends AppFailure {
  const UnknownFailure({
    required super.message,
    super.code = 'UNKNOWN_ERROR',
    super.details,
  });
}
