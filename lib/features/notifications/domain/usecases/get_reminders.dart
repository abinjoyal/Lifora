import '../entities/memory_reminder.dart';
import '../repositories/notification_repository.dart';

class GetReminders {
  GetReminders(this._repository);

  final NotificationRepository _repository;

  Future<List<MemoryReminder>> call() {
    return _repository.getReminders();
  }
}

