import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/usecases/get_notification_settings.dart';
import '../../domain/usecases/save_notification_settings.dart';
import 'notification_provider.dart';

class NotificationSettingsState {
  const NotificationSettingsState({
    this.settings = const NotificationSettings(),
    this.hasPermission = true,
    this.isLoading = false,
    this.errorMessage,
  });

  final NotificationSettings settings;
  final bool hasPermission;
  final bool isLoading;
  final String? errorMessage;

  NotificationSettingsState copyWith({
    NotificationSettings? settings,
    bool? hasPermission,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotificationSettingsState(
      settings: settings ?? this.settings,
      hasPermission: hasPermission ?? this.hasPermission,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class NotificationSettingsNotifier
    extends StateNotifier<NotificationSettingsState> {
  NotificationSettingsNotifier({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
    required this.checkPermissionFn,
    required this.requestPermissionFn,
  }) : super(const NotificationSettingsState(isLoading: true)) {
    loadSettings();
  }

  final GetNotificationSettings getSettingsUseCase;
  final SaveNotificationSettings saveSettingsUseCase;
  final Future<bool> Function() checkPermissionFn;
  final Future<bool> Function() requestPermissionFn;

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final settings = await getSettingsUseCase();
      final hasPerm = await checkPermissionFn();

      state = state.copyWith(
        settings: settings,
        hasPermission: hasPerm,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    state = state.copyWith(settings: newSettings);

    try {
      await saveSettingsUseCase(newSettings);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<bool> requestNotificationPermission() async {
    final granted = await requestPermissionFn();
    state = state.copyWith(hasPermission: granted);
    return granted;
  }
}

final notificationSettingsNotifierProvider = StateNotifierProvider<
    NotificationSettingsNotifier, NotificationSettingsState>((ref) {
  final getSettings = ref.watch(getNotificationSettingsUseCaseProvider);
  final saveSettings = ref.watch(saveNotificationSettingsUseCaseProvider);
  final repo = ref.watch(notificationRepositoryProvider);

  return NotificationSettingsNotifier(
    getSettingsUseCase: getSettings,
    saveSettingsUseCase: saveSettings,
    checkPermissionFn: repo.checkPermission,
    requestPermissionFn: repo.requestPermission,
  );
});

