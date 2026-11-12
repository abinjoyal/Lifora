import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

class GetInboxNotifications {
  GetInboxNotifications(this._repository);

  final NotificationRepository _repository;

  Future<List<AppNotification>> call() {
    return _repository.getInboxNotifications();
  }
}

