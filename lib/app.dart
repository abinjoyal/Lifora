import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_provider.dart';

class LiforaApp extends ConsumerWidget {
  const LiforaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          // Ensure consistent text scaling and responsive layout boundaries
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(
              context,
            ).textScaler.clamp(minScaleFactor: 0.85, maxScaleFactor: 1.25),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
