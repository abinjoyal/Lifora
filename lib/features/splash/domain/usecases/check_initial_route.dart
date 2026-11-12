import '../../../../core/constants/route_constants.dart';
import '../repositories/splash_repository.dart';

class CheckInitialRoute {
  const CheckInitialRoute(this._repository);

  final SplashRepository _repository;

  Future<String> call() async {
    try {
      final bool onboardingDone = await _repository.isOnboardingCompleted();
      if (!onboardingDone) {
        return RouteConstants.onboardingPath;
      }

      final String? storageUri = await _repository.getSavedStorageUri();
      if (storageUri == null || storageUri.trim().isEmpty) {
        return RouteConstants.storageSetupPath;
      }

      final bool isPermissionValid = await _repository.isStoragePermissionValid(
        storageUri,
      );
      if (isPermissionValid) {
        return RouteConstants.homePath;
      }

      // If permissions were revoked by user/system, route back to storage setup to re-grant
      return RouteConstants.storageSetupPath;
    } catch (_) {
      // In case of initial read error, safely direct to onboarding
      return RouteConstants.onboardingPath;
    }
  }
}
