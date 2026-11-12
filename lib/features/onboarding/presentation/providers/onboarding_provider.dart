import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/entities/onboarding_page.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_onboarding_pages.dart';

final getOnboardingPagesUseCaseProvider = Provider<GetOnboardingPages>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return GetOnboardingPages(repo);
});

final completeOnboardingUseCaseProvider = Provider<CompleteOnboarding>((ref) {
  final repo = ref.watch(onboardingRepositoryProvider);
  return CompleteOnboarding(repo);
});

class OnboardingState {
  const OnboardingState({
    required this.currentPage,
    required this.pages,
    this.isCompleting = false,
    this.isCompleted = false,
  });

  final int currentPage;
  final List<OnboardingPageEntity> pages;
  final bool isCompleting;
  final bool isCompleted;

  bool get isLastPage => currentPage == pages.length - 1;

  OnboardingState copyWith({
    int? currentPage,
    List<OnboardingPageEntity>? pages,
    bool? isCompleting,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      pages: pages ?? this.pages,
      isCompleting: isCompleting ?? this.isCompleting,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier({
    required GetOnboardingPages getOnboardingPages,
    required this.completeOnboarding,
  }) : super(OnboardingState(currentPage: 0, pages: getOnboardingPages()));

  final CompleteOnboarding completeOnboarding;

  void onPageChanged(int index) {
    if (state.currentPage != index) {
      state = state.copyWith(currentPage: index);
    }
  }

  void handleNext(PageController controller) {
    if (state.isLastPage) {
      complete();
    } else {
      controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> skip() async {
    await complete();
  }

  Future<void> complete() async {
    if (state.isCompleting || state.isCompleted) return;

    state = state.copyWith(isCompleting: true);
    try {
      await completeOnboarding();
      state = state.copyWith(isCompleting: false, isCompleted: true);
    } catch (_) {
      state = state.copyWith(isCompleting: false);
    }
  }
}

final onboardingNotifierProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>((
      ref,
    ) {
      final getPages = ref.watch(getOnboardingPagesUseCaseProvider);
      final completeUseCase = ref.watch(completeOnboardingUseCaseProvider);
      return OnboardingNotifier(
        getOnboardingPages: getPages,
        completeOnboarding: completeUseCase,
      );
    });
