import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/calendar/presentation/pages/calendar_year_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/location/presentation/pages/location_map_page.dart';
import '../../features/location/presentation/pages/location_picker_page.dart';
import '../../features/location/presentation/pages/location_search_page.dart';
import '../../features/map/presentation/pages/memory_map_page.dart';
import '../../features/memories/presentation/pages/create_memory_page.dart';
import '../../features/memories/presentation/pages/edit_memory_page.dart';
import '../../features/memories/presentation/pages/memories_page.dart';
import '../../features/memories/presentation/pages/memory_details_page.dart';
import '../../features/notifications/domain/entities/memory_reminder.dart';
import '../../features/notifications/presentation/pages/create_reminder_page.dart';
import '../../features/notifications/presentation/pages/notification_settings_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/notifications/presentation/pages/reminders_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/photos/presentation/pages/photo_album_page.dart';
import '../../features/photos/presentation/pages/photo_picker_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/about_page.dart';
import '../../features/settings/presentation/pages/appearance_settings_page.dart';
import '../../features/settings/presentation/pages/backup_export_page.dart';
import '../../features/settings/presentation/pages/language_settings_page.dart';
import '../../features/settings/presentation/pages/privacy_settings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/storage_management_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/storage/presentation/pages/storage_setup_page.dart';
import '../../features/storage/presentation/pages/storage_success_page.dart';
import '../constants/route_constants.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteConstants.splashPath,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: RouteConstants.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteConstants.onboardingPath,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteConstants.storageSetupPath,
        name: RouteNames.storageSetup,
        builder: (context, state) => const StorageSetupPage(),
      ),
      GoRoute(
        path: RouteConstants.setupSuccessPath,
        name: RouteNames.setupSuccess,
        builder: (context, state) => const StorageSuccessPage(),
      ),
      GoRoute(
        path: RouteConstants.getStartedPath,
        name: RouteNames.getStarted,
        builder: (context, state) => const _RoutePlaceholderScreen(
          title: 'Get Started',
          description: 'Ready to write your first journal entry.',
          nextRoute: RouteConstants.homePath,
          nextRouteLabel: 'Enter Lifora Home',
        ),
      ),
      GoRoute(
        path: RouteConstants.homePath,
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteConstants.createMemoryPath,
        name: RouteNames.createMemory,
        builder: (context, state) => CreateMemoryPage(
          initialDate: state.extra as DateTime?,
        ),
      ),
      GoRoute(
        path: RouteConstants.searchPath,
        name: RouteNames.search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: RouteConstants.notificationsPath,
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: RouteConstants.notificationSettingsPath,
        name: RouteNames.notificationSettings,
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: RouteConstants.notificationRemindersPath,
        name: RouteNames.notificationReminders,
        builder: (context, state) => const RemindersPage(),
      ),
      GoRoute(
        path: RouteConstants.notificationCreateReminderPath,
        name: RouteNames.notificationCreateReminder,
        builder: (context, state) => CreateReminderPage(
          initialReminder: state.extra as MemoryReminder?,
        ),
      ),
      GoRoute(
        path: RouteConstants.favoritesPath,
        name: RouteNames.favorites,
        builder: (context, state) => const _RoutePlaceholderScreen(
          title: 'Favorite Memories',
          description: 'Your starred and favorite memories vault.',
        ),
      ),
      GoRoute(
        path: RouteConstants.memoriesPath,
        name: RouteNames.memories,
        builder: (context, state) => const MemoriesPage(),
      ),
      GoRoute(
        path: RouteConstants.memoryDetailsPath,
        name: RouteNames.memoryDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MemoryDetailsPage(memoryId: id);
        },
      ),
      GoRoute(
        path: RouteConstants.memoryEditPath,
        name: RouteNames.memoryEdit,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return EditMemoryPage(memoryId: id);
        },
      ),
      GoRoute(
        path: RouteConstants.photoPickerPath,
        name: RouteNames.photoPicker,
        builder: (context, state) => const PhotoPickerPage(),
      ),
      GoRoute(
        path: RouteConstants.photoAlbumsPath,
        name: RouteNames.photoAlbums,
        builder: (context, state) => const PhotoAlbumPage(),
      ),
      GoRoute(
        path: RouteConstants.locationPickerPath,
        name: RouteNames.locationPicker,
        builder: (context, state) => const LocationPickerPage(),
      ),
      GoRoute(
        path: RouteConstants.locationMapPath,
        name: RouteNames.locationMap,
        builder: (context, state) => const LocationMapPage(),
      ),
      GoRoute(
        path: RouteConstants.locationSearchPath,
        name: RouteNames.locationSearch,
        builder: (context, state) => const LocationSearchPage(),
      ),
      GoRoute(
        path: RouteConstants.calendarPath,
        name: RouteNames.calendar,
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: RouteConstants.calendarYearPath,
        name: RouteNames.calendarYear,
        builder: (context, state) {
          final yearStr = state.pathParameters['year'];
          final year = int.tryParse(yearStr ?? '') ?? DateTime.now().year;
          return CalendarYearPage(initialYear: year);
        },
      ),
      GoRoute(
        path: RouteConstants.mapPath,
        name: RouteNames.map,
        builder: (context, state) => const MemoryMapPage(),
      ),
      GoRoute(
        path: RouteConstants.profilePath,
        name: RouteNames.profile,
        builder: (context, state) => const _RoutePlaceholderScreen(
          title: 'User Profile',
          description: 'Memory stats, journals count, and personal vault info.',
          nextRoute: RouteConstants.settingsPath,
          nextRouteLabel: 'Open Settings',
        ),
      ),
      GoRoute(
        path: RouteConstants.settingsPath,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteConstants.settingsAppearancePath,
        name: RouteNames.settingsAppearance,
        builder: (context, state) => const AppearanceSettingsPage(),
      ),
      GoRoute(
        path: RouteConstants.settingsLanguagePath,
        name: RouteNames.settingsLanguage,
        builder: (context, state) => const LanguageSettingsPage(),
      ),
      GoRoute(
        path: RouteConstants.settingsStoragePath,
        name: RouteNames.settingsStorage,
        builder: (context, state) => const StorageManagementPage(),
      ),
      GoRoute(
        path: RouteConstants.settingsPrivacyPath,
        name: RouteNames.settingsPrivacy,
        builder: (context, state) => const PrivacySettingsPage(),
      ),
      GoRoute(
        path: RouteConstants.settingsBackupPath,
        name: RouteNames.settingsBackup,
        builder: (context, state) => const BackupExportPage(),
      ),
      GoRoute(
        path: RouteConstants.settingsAboutPath,
        name: RouteNames.settingsAbout,
        builder: (context, state) => const AboutPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              Text('Route error: ${state.uri}', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(RouteConstants.homePath),
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});

class _RoutePlaceholderScreen extends StatelessWidget {
  const _RoutePlaceholderScreen({
    required this.title,
    required this.description,
    this.nextRoute,
    this.nextRouteLabel,
  });

  final String title;
  final String description;
  final String? nextRoute;
  final String? nextRouteLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories_outlined,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (nextRoute != null) ...[
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.go(nextRoute!),
                    child: Text(nextRouteLabel ?? 'Next'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
