import '../entities/onboarding_page.dart';

abstract class OnboardingRepository {
  /// Returns the configured list of onboarding pages.
  List<OnboardingPageEntity> getOnboardingPages();

  /// Checks whether user has already completed onboarding.
  Future<bool> isOnboardingCompleted();

  /// Marks onboarding as completed and persists the preference.
  Future<void> completeOnboarding();
}
