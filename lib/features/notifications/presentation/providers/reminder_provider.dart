import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memory_reminder.dart';
import '../../domain/usecases/delete_reminder.dart';
import '../../domain/usecases/get_reminders.dart';
import '../../domain/usecases/save_reminder.dart';
import '../../domain/usecases/toggle_reminder_status.dart';
import 'notification_provider.dart';

class ReminderState {
  const ReminderState({
    this.reminders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<MemoryReminder> reminders;
  final bool isLoading;
  final String? errorMessage;

  ReminderState copyWith({
    List<MemoryReminder>? reminders,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier({
    required this.getRemindersUseCase,
    required this.saveReminderUseCase,
    required this.deleteReminderUseCase,
    required this.toggleReminderStatusUseCase,
  }) : super(const ReminderState(isLoading: true)) {
    loadReminders();
  }

  final GetReminders getRemindersUseCase;
  final SaveReminder saveReminderUseCase;
  final DeleteReminder deleteReminderUseCase;
  final ToggleReminderStatus toggleReminderStatusUseCase;

  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final list = await getRemindersUseCase();
      state = state.copyWith(
        reminders: list,
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

  Future<void> saveReminder(MemoryReminder reminder) async {
    state = state.copyWith(isLoading: true);

    try {
      await saveReminderUseCase(reminder);
      final list = await getRemindersUseCase();
      state = state.copyWith(
        reminders: list,
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

  Future<void> toggleReminder(String id, bool isEnabled) async {
    try {
      await toggleReminderStatusUseCase(id, isEnabled);
      final list = state.reminders.map((r) {
        if (r.id == id) {
          return r.copyWith(isEnabled: isEnabled);
        }
        return r;
      }).toList();
      state = state.copyWith(reminders: list);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      await deleteReminderUseCase(id);
      final list = state.reminders.where((r) => r.id != id).toList();
      state = state.copyWith(reminders: list);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

final reminderNotifierProvider =
    StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  final getReminders = ref.watch(getRemindersUseCaseProvider);
  final saveRem = ref.watch(saveReminderUseCaseProvider);
  final delRem = ref.watch(deleteReminderUseCaseProvider);
  final toggleRem = ref.watch(toggleReminderStatusUseCaseProvider);

  return ReminderNotifier(
    getRemindersUseCase: getReminders,
    saveReminderUseCase: saveRem,
    deleteReminderUseCase: delRem,
    toggleReminderStatusUseCase: toggleRem,
  );
});

