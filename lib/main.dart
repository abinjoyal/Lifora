import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  // Catch synchronous Dart/Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('[FlutterError] ${details.exceptionAsString()}');
    if (details.stack != null) {
      debugPrint('[FlutterStackTrace] ${details.stack}');
    }
  };

  // Catch unhandled asynchronous errors from platform dispatcher
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('[PlatformDispatcherError] $error');
    debugPrint('[PlatformDispatcherStack] $stack');
    return true; // Marked as handled
  };

  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Configure system UI overlay for edge-to-edge look
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );

      // Safe initialization of background services
      final container = ProviderContainer();
      try {
        final notificationService = container.read(notificationServiceProvider);
        await notificationService.initialize();
      } catch (e) {
        debugPrint('[Startup] Notification service initialisation skipped: $e');
      }

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const LiforaApp(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint('[RootZonedError] $error');
      debugPrint('[RootZonedStack] $stackTrace');
    },
  );
}
