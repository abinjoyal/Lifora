import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/platform_channel_service.dart';
import '../../domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl({required this.platformChannelService});

  final PlatformChannelService platformChannelService;

  // In-memory / preference flags (will bridge to SharedPreferences when integrated)
  bool _mockOnboardingCompleted = false;
  String? _mockSavedUri;

  @override
  Future<bool> isOnboardingCompleted() async {
    // In production, reads the persistent onboarding key from settings storage
    return _mockOnboardingCompleted;
  }

  @override
  Future<String?> getSavedStorageUri() async {
    // In production, reads the persisted SAF URI string
    return _mockSavedUri;
  }

  @override
  Future<bool> isStoragePermissionValid(String uri) async {
    try {
      return await platformChannelService.hasUriPermission(uri);
    } catch (_) {
      return false;
    }
  }

  // Helper for testing/dev navigation simulation
  void setMockState({bool onboardingDone = false, String? uri}) {
    _mockOnboardingCompleted = onboardingDone;
    _mockSavedUri = uri;
  }
}

final splashRepositoryProvider = Provider<SplashRepository>((ref) {
  final platformService = ref.watch(platformChannelServiceProvider);
  return SplashRepositoryImpl(platformChannelService: platformService);
});
