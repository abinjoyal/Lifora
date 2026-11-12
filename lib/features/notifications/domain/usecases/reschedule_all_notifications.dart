import '../repositories/notification_repository.dart';

class RescheduleAllNotifications {
  RescheduleAllNotifications(this._repository);

  final NotificationRepository _repository;

  Future<void> call() {
    return _repository.rescheduleAllNotifications();
  }
}

