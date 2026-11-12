import 'package:flutter/material.dart';
import '../../domain/entities/app_notification.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconData(notification.type);
    final iconBgColor = _getIconBgColor(notification.type);
    final iconColor = _getIconColor(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red.shade400,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.transparent : _peach.withValues(alpha: 0.15),
            border: const Border(
              bottom: BorderSide(color: Color(0xFFF0E5DB), width: 0.8),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Circle
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, size: 20.0, color: iconColor),
              ),
              const SizedBox(width: 14.0),

              // Title, Body & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                              color: _mainText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 11.5,
                            color: notification.isRead
                                ? _secondaryText
                                : _primaryOrange,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: _secondaryText,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Unread Indicator Dot
              if (!notification.isRead) ...[
                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: _primaryOrange,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.onThisDay:
        return Icons.auto_awesome_rounded;
      case AppNotificationType.customReminder:
        return Icons.alarm_rounded;
      case AppNotificationType.dailyReminder:
        return Icons.edit_calendar_rounded;
      case AppNotificationType.memorySaved:
        return Icons.check_circle_outline_rounded;
      case AppNotificationType.anniversary:
        return Icons.cake_rounded;
    }
  }

  Color _getIconBgColor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.onThisDay:
        return _peach.withValues(alpha: 0.6);
      case AppNotificationType.customReminder:
        return const Color(0xFFE8F5E9);
      case AppNotificationType.dailyReminder:
        return const Color(0xFFE3F2FD);
      case AppNotificationType.memorySaved:
        return const Color(0xFFF3E5F5);
      case AppNotificationType.anniversary:
        return const Color(0xFFFFF3E0);
    }
  }

  Color _getIconColor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.onThisDay:
        return _primaryOrange;
      case AppNotificationType.customReminder:
        return Colors.green.shade700;
      case AppNotificationType.dailyReminder:
        return Colors.blue.shade700;
      case AppNotificationType.memorySaved:
        return Colors.purple.shade700;
      case AppNotificationType.anniversary:
        return Colors.orange.shade800;
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      final mins = diff.inMinutes.clamp(1, 60);
      return '$mins m ago';
    } else if (diff.inHours < 24 && date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}

