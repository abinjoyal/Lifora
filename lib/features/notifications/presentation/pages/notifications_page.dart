import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../memories/presentation/providers/memory_provider.dart';
import '../../domain/entities/app_notification.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_card.dart';
import '../widgets/notification_empty_state.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  static const Color _warmBackground = Color(0xFFFFF8F1);
  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxState = ref.watch(notificationInboxNotifierProvider);
    final inboxNotifier =
        ref.read(notificationInboxNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: _warmBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (inboxState.unreadCount > 0)
            TextButton(
              onPressed: inboxNotifier.markAllAsRead,
              child: const Text(
                'Mark All Read',
                style: TextStyle(
                  color: _primaryOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: _mainText),
            tooltip: 'Notification Settings',
            onPressed: () =>
                context.push(RouteConstants.notificationSettingsPath),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: _primaryOrange,
          onRefresh: inboxNotifier.loadNotifications,
          child: inboxState.isEmpty
              ? const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: NotificationEmptyState(),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section A: Today
                      if (inboxState.todayNotifications.isNotEmpty) ...[
                        _buildSectionHeader('Today'),
                        ...inboxState.todayNotifications.map(
                          (notif) => NotificationCard(
                            notification: notif,
                            onTap: () => _handleNotificationTap(
                                context, ref, notif, inboxNotifier),
                            onDelete: () =>
                                inboxNotifier.deleteNotification(notif.id),
                          ),
                        ),
                      ],

                      // Section B: Yesterday
                      if (inboxState.yesterdayNotifications.isNotEmpty) ...[
                        _buildSectionHeader('Yesterday'),
                        ...inboxState.yesterdayNotifications.map(
                          (notif) => NotificationCard(
                            notification: notif,
                            onTap: () => _handleNotificationTap(
                                context, ref, notif, inboxNotifier),
                            onDelete: () =>
                                inboxNotifier.deleteNotification(notif.id),
                          ),
                        ),
                      ],

                      // Section C: Earlier
                      if (inboxState.earlierNotifications.isNotEmpty) ...[
                        _buildSectionHeader('Earlier'),
                        ...inboxState.earlierNotifications.map(
                          (notif) => NotificationCard(
                            notification: notif,
                            onTap: () => _handleNotificationTap(
                                context, ref, notif, inboxNotifier),
                            onDelete: () =>
                                inboxNotifier.deleteNotification(notif.id),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.alarm_rounded, size: 20),
        label: const Text('Reminders'),
        onPressed: () => context.push(RouteConstants.notificationRemindersPath),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 4.0),
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

  Future<void> _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
    NotificationInboxNotifier notifier,
  ) async {
    // 1. Mark as read
    notifier.markAsRead(notification.id);

    // 2. Navigate if linked to memory
    if (notification.linkedMemoryId != null) {
      final memoryRepo = ref.read(memoryRepositoryProvider);
      final memory =
          await memoryRepo.getMemoryById(notification.linkedMemoryId!);

      if (context.mounted) {
        if (memory != null) {
          context.push(RouteConstants.memoryDetailsUrl(memory.id));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Linked memory was removed or could not be found.'),
            ),
          );
        }
      }
    }
  }
}

