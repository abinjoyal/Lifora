abstract class SplashRepository {
  /// Checks whether user has completed the initial onboarding walkthrough.
  Future<bool> isOnboardingCompleted();

  /// Retrieves the saved Storage Access Framework (SAF) folder tree URI, if any.
  Future<String?> getSavedStorageUri();

  /// Checks whether the persistent SAF permissions for the saved URI are still valid.
  Future<bool> isStoragePermissionValid(String uri);
}
