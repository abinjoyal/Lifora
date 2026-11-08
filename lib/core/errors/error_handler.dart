import 'dart:io';
import 'package:flutter/services.dart';
import 'app_exception.dart';
import 'app_failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static AppFailure handle(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return _mapAppException(error);
    }

    if (error is PlatformException) {
      return StorageFailure(
        message: error.message ?? 'Platform operation failed.',
        code: error.code,
        details: error.details,
      );
    }

    if (error is FileSystemException) {
      return FileOperationFailure(
        message: error.message.isNotEmpty
            ? error.message
            : 'File operation error on ${error.path ?? 'unknown path'}.',
        code: 'FILE_SYSTEM_ERROR',
        details: error.osError?.message,
      );
    }

    if (error is FormatException) {
      return ValidationFailure(
        message: error.message,
        code: 'FORMAT_ERROR',
        details: error.source,
      );
    }

    return UnknownFailure(
      message: error.toString().isNotEmpty
          ? error.toString()
          : 'An unexpected error occurred.',
      code: 'UNEXPECTED_ERROR',
      details: stackTrace?.toString(),
    );
  }

  static AppFailure _mapAppException(AppException exception) {
    return switch (exception) {
      StorageException e => StorageFailure(
        message: e.message,
        details: e.cause ?? e.path,
      ),
      PermissionException e => PermissionFailure(
        message: e.message,
        details: e.cause ?? e.permission,
      ),
      FileOperationException e => FileOperationFailure(
        message: e.message,
        details: e.cause ?? e.filePath,
      ),
      DatabaseException e => DatabaseFailure(
        message: e.message,
        details: e.cause,
      ),
      LocationException e => LocationFailure(
        message: e.message,
        details: e.cause,
      ),
      NetworkException e => NetworkFailure(
        message: e.message,
        details: e.cause,
      ),
      ValidationException e => ValidationFailure(
        message: e.message,
        details: e.cause ?? e.field,
      ),
    };
  }
}
