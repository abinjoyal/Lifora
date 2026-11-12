import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/onboarding_action_button.dart';
import '../widgets/onboarding_description.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_illustration.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_title.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;

  // Warm background color matching design system
  static const Color _warmBackground = Color(0xFFFFF8F1);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    // Listen for completion and navigate to storage setup
    ref.listen<OnboardingState>(onboardingNotifierProvider, (_, next) {
      if (next.isCompleted) {
        context.go(RouteConstants.storageSetupPath);
      }
    });

    final currentPageData = state.pages[state.currentPage];

    return Scaffold(
      backgroundColor: _warmBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Persistent Header
            OnboardingHeader(
              onSkip: () => notifier.skip(),
              showSkip: !state.isLastPage,
            ),

            // Middle: Swipeable PageView with Illustration, Title, Description
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: state.pages.length,
                onPageChanged: (index) => notifier.onPageChanged(index),
                itemBuilder: (context, index) {
                  final page = state.pages[index];

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12.0),

                          // Illustration
                          OnboardingIllustration(
                            imagePath: page.illustrationPath,
                            pageIndex: page.index,
                          ),

                          const SizedBox(height: 24.0),

                          // Title
                          OnboardingTitle(title: page.title),

                          const SizedBox(height: 12.0),

                          // Description
                          OnboardingDescription(description: page.description),

                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Area: Indicators & Action Button
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 3-dot Animated Page Indicator
                  OnboardingPageIndicator(
                    currentPage: state.currentPage,
                    pageCount: state.pages.length,
                  ),

                  const SizedBox(height: 24.0),

                  // Full-width Gradient Action Button
                  OnboardingActionButton(
                    text: currentPageData.buttonText,
                    isLoading: state.isCompleting,
                    onPressed: () => notifier.handleNext(_pageController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
