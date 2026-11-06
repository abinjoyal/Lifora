class AppConstants {
  AppConstants._();

  static const String appName = 'Lifora';
  static const String appTagline = 'Your Personal Memory Journal';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  // Default Application Settings
  static const bool defaultDarkMode = false;
  static const bool defaultAutoBackup = false;
  static const bool defaultBiometricLock = false;
  static const int maxTitleLength = 120;
  static const int maxDescriptionLength = 5000;
  static const int maxImagesPerMemory = 10;
  static const int thumbnailQuality = 80;
  static const int thumbnailSize = 300;

  // Cache and Debounce
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(milliseconds: 2000);
}
