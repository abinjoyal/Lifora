enum ReminderRepeatType {
  never,
  daily,
  weekly,
  monthly,
  yearly,
}

enum ReminderCategoryType {
  general,
  birthday,
  anniversary,
  trip,
  custom,
}

class MemoryReminder {
  const MemoryReminder({
    required this.id,
    required this.title,
    this.description,
    required this.reminderDate,
    required this.reminderTimeHour,
    required this.reminderTimeMinute,
    this.linkedMemoryId,
    this.categoryType = ReminderCategoryType.general,
    this.repeatType = ReminderRepeatType.never,
    this.isEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final DateTime reminderDate;
  final int reminderTimeHour;
  final int reminderTimeMinute;
  final String? linkedMemoryId;
  final ReminderCategoryType categoryType;
  final ReminderRepeatType repeatType;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  DateTime get scheduledDateTime => DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        reminderTimeHour,
        reminderTimeMinute,
      );

  bool get isUpcoming {
    return scheduledDateTime.isAfter(DateTime.now());
  }

  String get formattedTime {
    final hour = reminderTimeHour.toString().padLeft(2, '0');
    final minute = reminderTimeMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  MemoryReminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? reminderDate,
    int? reminderTimeHour,
    int? reminderTimeMinute,
    String? linkedMemoryId,
    ReminderCategoryType? categoryType,
    ReminderRepeatType? repeatType,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MemoryReminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderDate: reminderDate ?? this.reminderDate,
      reminderTimeHour: reminderTimeHour ?? this.reminderTimeHour,
      reminderTimeMinute: reminderTimeMinute ?? this.reminderTimeMinute,
      linkedMemoryId: linkedMemoryId ?? this.linkedMemoryId,
      categoryType: categoryType ?? this.categoryType,
      repeatType: repeatType ?? this.repeatType,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryReminder &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          reminderDate == other.reminderDate &&
          reminderTimeHour == other.reminderTimeHour &&
          reminderTimeMinute == other.reminderTimeMinute &&
          linkedMemoryId == other.linkedMemoryId &&
          categoryType == other.categoryType &&
          repeatType == other.repeatType &&
          isEnabled == other.isEnabled &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      reminderDate.hashCode ^
      reminderTimeHour.hashCode ^
      reminderTimeMinute.hashCode ^
      linkedMemoryId.hashCode ^
      categoryType.hashCode ^
      repeatType.hashCode ^
      isEnabled.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

