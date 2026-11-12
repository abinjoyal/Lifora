import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/splash_repository_impl.dart';
import '../../domain/usecases/check_initial_route.dart';

final checkInitialRouteUseCaseProvider = Provider<CheckInitialRoute>((ref) {
  final repository = ref.watch(splashRepositoryProvider);
  return CheckInitialRoute(repository);
});

class SplashNotifier extends StateNotifier<AsyncValue<String?>> {
  SplashNotifier(this._checkInitialRoute) : super(const AsyncValue.data(null));

  final CheckInitialRoute _checkInitialRoute;
  bool _hasStarted = false;

  Future<void> initialize() async {
    if (_hasStarted) return;
    _hasStarted = true;

    state = const AsyncValue.loading();

    try {
      // Run routing determination concurrently with minimum visual display duration (1.5s)
      final results = await Future.wait([
        _checkInitialRoute(),
        Future<void>.delayed(const Duration(milliseconds: 1500)),
      ]);

      final destinationRoute = results.first as String;
      state = AsyncValue.data(destinationRoute);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final splashNotifierProvider =
    StateNotifierProvider.autoDispose<SplashNotifier, AsyncValue<String?>>((
      ref,
    ) {
      final checkInitialRoute = ref.watch(checkInitialRouteUseCaseProvider);
      return SplashNotifier(checkInitialRoute);
    });
