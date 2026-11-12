import '../repositories/notification_repository.dart';

class DeleteReminder {
  DeleteReminder(this._repository);

  final NotificationRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteReminder(id);
  }
}

