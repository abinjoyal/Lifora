import '../repositories/notification_repository.dart';

class ToggleReminderStatus {
  ToggleReminderStatus(this._repository);

  final NotificationRepository _repository;

  Future<void> call(String id, bool isEnabled) {
    return _repository.toggleReminder(id, isEnabled);
  }
}

