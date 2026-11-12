import 'package:flutter/material.dart';
import '../../domain/entities/memory_reminder.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final MemoryReminder reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const Color _primaryOrange = Color(0xFFF47B45);
  static const Color _peach = Color(0xFFFFE2CC);
  static const Color _mainText = Color(0xFF38251F);
  static const Color _secondaryText = Color(0xFF806A60);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      padding: const EdgeInsets.all(14.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title, Category Icon & Switch
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _peach.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getCategoryIcon(reminder.categoryType),
                  color: _primaryOrange,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: _mainText,
                      ),
                    ),
                    if (reminder.description?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          reminder.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: _secondaryText,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Switch(
                value: reminder.isEnabled,
                activeThumbColor: _primaryOrange,
                onChanged: onToggle,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF0E5DB), height: 1),
          const SizedBox(height: 10),

          // Bottom Row: Date, Time, Repeat & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: _secondaryText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${reminder.reminderDate.day}/${reminder.reminderDate.month}/${reminder.reminderDate.year} at ${reminder.formattedTime}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: _secondaryText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: _peach.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      _getRepeatText(reminder.repeatType),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: _primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: _secondaryText,
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Edit',
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    color: Colors.red.shade400,
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(ReminderCategoryType type) {
    switch (type) {
      case ReminderCategoryType.birthday:
        return Icons.cake_rounded;
      case ReminderCategoryType.anniversary:
        return Icons.favorite_rounded;
      case ReminderCategoryType.trip:
        return Icons.flight_takeoff_rounded;
      case ReminderCategoryType.general:
      case ReminderCategoryType.custom:
        return Icons.alarm_rounded;
    }
  }

  String _getRepeatText(ReminderRepeatType repeat) {
    switch (repeat) {
      case ReminderRepeatType.never:
        return 'Once';
      case ReminderRepeatType.daily:
        return 'Daily';
      case ReminderRepeatType.weekly:
        return 'Weekly';
      case ReminderRepeatType.monthly:
        return 'Monthly';
      case ReminderRepeatType.yearly:
        return 'Yearly';
    }
  }
}

