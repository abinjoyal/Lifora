import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

class HomeNotificationButton extends ConsumerWidget {
  const HomeNotificationButton({super.key});

  static const Color _iconColor = Color(0xFF38251F);
  static const Color _badgeColor = Color(0xFFF47B45);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount =
        ref.watch(notificationInboxNotifierProvider).unreadCount;
    final hasUnread = unreadCount > 0;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: _iconColor,
            size: 24,
          ),
          tooltip: 'Notifications',
          onPressed: () => context.push(RouteConstants.notificationsPath),
        ),
        if (hasUnread)
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _badgeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
