sealed class AppException implements Exception {
  const AppException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

class StorageException extends AppException {
  const StorageException(super.message, [super.cause, this.path]);

  final String? path;
}

class PermissionException extends AppException {
  const PermissionException(super.message, [super.cause, this.permission]);

  final String? permission;
}

class FileOperationException extends AppException {
  const FileOperationException(super.message, [super.cause, this.filePath]);

  final String? filePath;
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.cause]);
}

class LocationException extends AppException {
  const LocationException(super.message, [super.cause]);
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.cause]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.cause, this.field]);

  final String? field;
}
