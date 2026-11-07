class RouteConstants {
  RouteConstants._();

  // Route Paths
  static const String splashPath = '/';
  static const String onboardingPath = '/onboarding';
  static const String storageSetupPath = '/storage-setup';
  static const String setupSuccessPath = '/setup-success';
  static const String getStartedPath = '/get-started';
  static const String homePath = '/home';
  static const String memoriesPath = '/memories';
  static const String calendarPath = '/calendar';
  static const String mapPath = '/map';
  static const String profilePath = '/profile';
  static const String settingsPath = '/settings';
  static const String settingsAppearancePath = '/settings/appearance';
  static const String settingsLanguagePath = '/settings/language';
  static const String settingsStoragePath = '/settings/storage';
  static const String settingsPrivacyPath = '/settings/privacy';
  static const String settingsBackupPath = '/settings/backup';
  static const String settingsAboutPath = '/settings/about';
  static const String createMemoryPath = '/create-memory';
  static const String searchPath = '/search';
  static const String notificationsPath = '/notifications';
  static const String notificationSettingsPath = '/notifications/settings';
  static const String notificationRemindersPath = '/notifications/reminders';
  static const String notificationCreateReminderPath =
      '/notifications/create-reminder';
  static const String favoritesPath = '/favorites';
  static const String memoryDetailsPath = '/memories/:id';
  static const String memoryEditPath = '/memories/:id/edit';
  static const String photoPickerPath = '/photos/picker';
  static const String photoPreviewPath = '/photos/preview';
  static const String photoAlbumsPath = '/photos/albums';
  static const String locationPickerPath = '/location/picker';
  static const String locationMapPath = '/location/map';
  static const String locationSearchPath = '/location/search';

  static const String calendarYearPath = '/calendar/year/:year';

  static String memoryDetailsUrl(String id) => '/memories/$id';
  static String memoryEditUrl(String id) => '/memories/$id/edit';
  static String calendarYearUrl(int year) => '/calendar/year/$year';
}
