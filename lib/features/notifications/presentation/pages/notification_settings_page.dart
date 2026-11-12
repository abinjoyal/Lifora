import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../providers/notification_settings_provider.dart';
import '../widgets/notification_permission_dialog.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(notificationSettingsNotifierProvider);
    final settings = settingsState.settings;
    final notifier =
        ref.read(notificationSettingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Permission Warning Banner if disabled at OS level
              if (!settingsState.hasPermission) ...[
                Container(
                  padding: const EdgeInsets.all(14.0),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: _primaryOrange.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_off_rounded,
                        color: _primaryOrange,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notifications Disabled',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _mainText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Enable system permission to receive memory reminders.',
                              style: TextStyle(
                                fontSize: 12,
                                color: _secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => NotificationPermissionDialog(
                              onContinue: notifier.requestNotificationPermission,
                            ),
                          );
                        },
                        child: const Text(
                          'Enable',
                          style: TextStyle(
                            color: _primaryOrange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // 2. Master Switch
              _buildSectionHeader('General'),
              _buildCard([
                SwitchListTile(
                  title: const Text(
                    'Allow Notifications',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _mainText,
                    ),
                  ),
                  subtitle: const Text(
                    'Master switch for all Lifora local notifications',
                    style: TextStyle(fontSize: 12, color: _secondaryText),
                  ),
                  value: settings.enableAllNotifications,
                  activeThumbColor: _primaryOrange,
                  onChanged: (val) {
                    notifier.updateSettings(
                      settings.copyWith(enableAllNotifications: val),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 20),

              // 3. Memory Reminders (On This Day & Daily Prompt)
              _buildSectionHeader('Memory Reminders'),
              _buildCard([
                // On This Day
                SwitchListTile(
                  title: const Text(
                    'On This Day',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _mainText,
                    ),
                  ),
                  subtitle: const Text(
                    'Revisit memories saved on this day in past years',
                    style: TextStyle(fontSize: 12, color: _secondaryText),
                  ),
                  value: settings.onThisDayEnabled &&
                      settings.enableAllNotifications,
                  activeThumbColor: _primaryOrange,
                  onChanged: settings.enableAllNotifications
                      ? (val) {
                          notifier.updateSettings(
                            settings.copyWith(onThisDayEnabled: val),
                          );
                        }
                      : null,
                ),
                if (settings.onThisDayEnabled && settings.enableAllNotifications)
                  ListTile(
                    title: const Text(
                      'Preferred Notification Time',
                      style: TextStyle(fontSize: 14, color: _mainText),
                    ),
                    trailing: Text(
                      _formatHourMinute(
                        settings.onThisDayHour,
                        settings.onThisDayMinute,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _primaryOrange,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: settings.onThisDayHour,
                          minute: settings.onThisDayMinute,
                        ),
                      );
                      if (picked != null) {
                        notifier.updateSettings(
                          settings.copyWith(
                            onThisDayHour: picked.hour,
                            onThisDayMinute: picked.minute,
                          ),
                        );
                      }
                    },
                  ),
                const Divider(height: 1, indent: 16, endIndent: 16),

                // Daily Prompt
                SwitchListTile(
                  title: const Text(
                    'Daily Journaling Prompt',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _mainText,
                    ),
                  ),
                  subtitle: const Text(
                    'Friendly reminder to capture a special moment each day',
                    style: TextStyle(fontSize: 12, color: _secondaryText),
                  ),
                  value: settings.dailyReminderEnabled &&
                      settings.enableAllNotifications,
                  activeThumbColor: _primaryOrange,
                  onChanged: settings.enableAllNotifications
                      ? (val) {
                          notifier.updateSettings(
                            settings.copyWith(dailyReminderEnabled: val),
                          );
                        }
                      : null,
                ),
                if (settings.dailyReminderEnabled &&
                    settings.enableAllNotifications)
                  ListTile(
                    title: const Text(
                      'Daily Reminder Time',
                      style: TextStyle(fontSize: 14, color: _mainText),
                    ),
                    trailing: Text(
                      _formatHourMinute(
                        settings.dailyReminderHour,
                        settings.dailyReminderMinute,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _primaryOrange,
                      ),
                    ),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: settings.dailyReminderHour,
                          minute: settings.dailyReminderMinute,
                        ),
                      );
                      if (picked != null) {
                        notifier.updateSettings(
                          settings.copyWith(
                            dailyReminderHour: picked.hour,
                            dailyReminderMinute: picked.minute,
                          ),
                        );
                      }
                    },
                  ),
              ]),
              const SizedBox(height: 20),

              // 4. Custom Reminders & Activity
              _buildSectionHeader('Custom Reminders & Activity'),
              _buildCard([
                SwitchListTile(
                  title: const Text(
                    'Custom Reminders',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _mainText,
                    ),
                  ),
                  subtitle: const Text(
                    'Receive scheduled birthday and personal reminders',
                    style: TextStyle(fontSize: 12, color: _secondaryText),
                  ),
                  value: settings.customRemindersEnabled &&
                      settings.enableAllNotifications,
                  activeThumbColor: _primaryOrange,
                  onChanged: settings.enableAllNotifications
                      ? (val) {
                          notifier.updateSettings(
                            settings.copyWith(customRemindersEnabled: val),
                          );
                        }
                      : null,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: const Text(
                    'Manage Reminders',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _mainText,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: _secondaryText,
                  ),
                  onTap: () =>
                      context.push(RouteConstants.notificationRemindersPath),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: const Text(
                    'Memory Saved Confirmation',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _mainText,
                    ),
                  ),
                  subtitle: const Text(
                    'Confirm when a memory is saved into your journal',
                    style: TextStyle(fontSize: 12, color: _secondaryText),
                  ),
                  value: settings.memorySavedConfirmation &&
                      settings.enableAllNotifications,
                  activeThumbColor: _primaryOrange,
                  onChanged: settings.enableAllNotifications
                      ? (val) {
                          notifier.updateSettings(
                            settings.copyWith(memorySavedConfirmation: val),
                          );
                        }
                      : null,
                ),
              ]),
              const SizedBox(height: 20),

              // 5. Privacy Settings
              _buildSectionHeader('Privacy'),
              _buildCard([
                SwitchListTile(
                  title: const Text(
                    'Privacy Mode',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _mainText,
                    ),
                  ),
                  subtitle: const Text(
                    'Hides personal memory titles and details in lock screen previews',
                    style: TextStyle(fontSize: 12, color: _secondaryText),
                  ),
                  value: settings.privacyModeEnabled,
                  activeThumbColor: _primaryOrange,
                  onChanged: (val) {
                    notifier.updateSettings(
                      settings.copyWith(privacyModeEnabled: val),
                    );
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w700,
          color: _secondaryText,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFEADBCE), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  String _formatHourMinute(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

