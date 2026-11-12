import '../entities/memory_reminder.dart';
import '../repositories/notification_repository.dart';

class SaveReminder {
  SaveReminder(this._repository);

  final NotificationRepository _repository;

  Future<void> call(MemoryReminder reminder) {
    return _repository.saveReminder(reminder);
  }
}

