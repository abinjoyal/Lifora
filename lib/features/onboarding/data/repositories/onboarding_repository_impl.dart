import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/asset_constants.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl();

  bool _isCompleted = false;

  @override
  List<OnboardingPageEntity> getOnboardingPages() {
    return const [
      OnboardingPageEntity(
        index: 0,
        title: 'Capture Your Special Moments',
        description:
            'Save your travel, family, friends and every special memory in one place.',
        illustrationPath: AssetConstants.onboarding1,
        buttonText: 'Continue',
      ),
      OnboardingPageEntity(
        index: 1,
        title: 'Organize & Find Easily',
        description:
            'Relive your memories anytime with dates, locations and a simple search.',
        illustrationPath: AssetConstants.onboarding2,
        buttonText: 'Continue',
      ),
      OnboardingPageEntity(
        index: 2,
        title: 'Your Memories. Your Control.',
        description:
            'Keep your photos and memories in your own folder. Enjoy offline access without needing an account.',
        illustrationPath: AssetConstants.onboarding3,
        buttonText: 'Get Started',
      ),
    ];
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _isCompleted;
  }

  @override
  Future<void> completeOnboarding() async {
    _isCompleted = true;
  }
}

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl();
});
