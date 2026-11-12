import '../repositories/notification_repository.dart';

class MarkNotificationAsRead {
  MarkNotificationAsRead(this._repository);

  final NotificationRepository _repository;

  Future<void> call(String id) {
    return _repository.markNotificationAsRead(id);
  }
}

