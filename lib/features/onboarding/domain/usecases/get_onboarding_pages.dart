import '../entities/onboarding_page.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingPages {
  const GetOnboardingPages(this._repository);

  final OnboardingRepository _repository;

  List<OnboardingPageEntity> call() {
    return _repository.getOnboardingPages();
  }
}
