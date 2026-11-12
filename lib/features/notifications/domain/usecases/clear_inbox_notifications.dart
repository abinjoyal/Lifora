import '../repositories/notification_repository.dart';

class ClearInboxNotifications {
  ClearInboxNotifications(this._repository);

  final NotificationRepository _repository;

  Future<void> call() {
    return _repository.clearAllNotifications();
  }
}

