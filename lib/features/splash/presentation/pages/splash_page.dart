import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/splash_provider.dart';
import '../widgets/splash_background.dart';
import '../widgets/splash_brand_name.dart';
import '../widgets/splash_loading_indicator.dart';
import '../widgets/splash_logo.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _animController.forward();

    // Trigger initial route resolution after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashNotifierProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navigateToRoute(String route) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for resolved initial route
    ref.listen<AsyncValue<String?>>(splashNotifierProvider, (_, next) {
      next.when(
        data: (route) {
          if (route != null && !_hasNavigated) {
            _navigateToRoute(route);
          }
        },
        error: (_, _) {
          if (!_hasNavigated) {
            _navigateToRoute(RouteConstants.onboardingPath);
          }
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: SplashBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Clean top white space
              const Spacer(flex: 3),

              // Center: Logo and Brand Name
              SplashLogo(animation: _animController),
              const SizedBox(height: 18),
              SplashBrandName(animation: _animController),

              // Bottom: Balanced space & minimal loading indicator
              const Spacer(flex: 3),
              const Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: SplashLoadingIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
