import '../repositories/notification_repository.dart';

class CheckAndScheduleOnThisDay {
  CheckAndScheduleOnThisDay(this._repository);

  final NotificationRepository _repository;

  Future<void> call() {
    return _repository.checkAndScheduleOnThisDay();
  }
}

