enum AppNotificationType {
  onThisDay,
  customReminder,
  dailyReminder,
  memorySaved,
  anniversary,
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.linkedMemoryId,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final AppNotificationType type;
  final String? linkedMemoryId;
  final DateTime createdAt;
  final bool isRead;

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    AppNotificationType? type,
    String? linkedMemoryId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      linkedMemoryId: linkedMemoryId ?? this.linkedMemoryId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          type == other.type &&
          linkedMemoryId == other.linkedMemoryId &&
          createdAt == other.createdAt &&
          isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      type.hashCode ^
      linkedMemoryId.hashCode ^
      createdAt.hashCode ^
      isRead.hashCode;
}

