import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/reminder_provider.dart';
import '../widgets/reminder_card.dart';

class RemindersPage extends ConsumerWidget {
  const RemindersPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderState = ref.watch(reminderNotifierProvider);
    final notifier = ref.read(reminderNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Memory Reminders'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: reminderState.reminders.isEmpty && !reminderState.isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE2CC).withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.alarm_on_rounded,
                          size: 36,
                          color: _primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Reminders Yet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _mainText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Schedule personal reminders for birthdays, anniversaries, or past travels.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: _secondaryText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () => context
                            .push(RouteConstants.notificationCreateReminderPath),
                        style: FilledButton.styleFrom(
                          backgroundColor: _primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Create Reminder'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8.0, bottom: 80.0),
                itemCount: reminderState.reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminderState.reminders[index];
                  return ReminderCard(
                    reminder: reminder,
                    onToggle: (enabled) {
                      notifier.toggleReminder(reminder.id, enabled);
                    },
                    onEdit: () {
                      context.push(
                        RouteConstants.notificationCreateReminderPath,
                        extra: reminder,
                      );
                    },
                    onDelete: () {
                      notifier.deleteReminder(reminder.id);
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        tooltip: 'Add Reminder',
        onPressed: () =>
            context.push(RouteConstants.notificationCreateReminderPath),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}

