import '../entities/notification_settings.dart';
import '../repositories/notification_repository.dart';

class GetNotificationSettings {
  GetNotificationSettings(this._repository);

  final NotificationRepository _repository;

  Future<NotificationSettings> call() {
    return _repository.getSettings();
  }
}

