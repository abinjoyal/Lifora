import '../repositories/notification_repository.dart';

class DeleteInboxNotification {
  DeleteInboxNotification(this._repository);

  final NotificationRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteNotification(id);
  }
}

