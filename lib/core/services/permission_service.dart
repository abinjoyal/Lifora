import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/app_exception.dart';

enum AppPermission { location, notification }

enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  unknown,
}

class PermissionService {
  PermissionService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('com.lifora.app/permissions');

  final MethodChannel _channel;

  /// Checks status of a permission.
  /// Lifora intentionally does NOT request broad external storage permissions
  /// because memory files are managed via Android Storage Access Framework (SAF).
  Future<PermissionStatus> checkPermission(AppPermission permission) async {
    try {
      final String result =
          await _channel.invokeMethod<String>('checkPermission', {
            'permission': permission.name,
          }) ??
          'unknown';

      return _mapStringToStatus(result);
    } on PlatformException catch (e) {
      debugPrint('Permission check error: ${e.message}');
      return PermissionStatus.unknown;
    } catch (e) {
      throw PermissionException(
        'Failed to check permission: ${permission.name}',
        e,
      );
    }
  }

  /// Requests permission only when required by user action.
  Future<PermissionStatus> requestPermission(AppPermission permission) async {
    try {
      final String result =
          await _channel.invokeMethod<String>('requestPermission', {
            'permission': permission.name,
          }) ??
          'denied';

      return _mapStringToStatus(result);
    } on PlatformException catch (e) {
      throw PermissionException(
        e.message ?? 'Permission request failed',
        e,
        permission.name,
      );
    } catch (e) {
      throw PermissionException(
        'Failed to request permission: ${permission.name}',
        e,
      );
    }
  }

  PermissionStatus _mapStringToStatus(String status) {
    return switch (status.toLowerCase()) {
      'granted' => PermissionStatus.granted,
      'denied' => PermissionStatus.denied,
      'permanently_denied' => PermissionStatus.permanentlyDenied,
      'restricted' => PermissionStatus.restricted,
      _ => PermissionStatus.unknown,
    };
  }
}

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionService();
});
