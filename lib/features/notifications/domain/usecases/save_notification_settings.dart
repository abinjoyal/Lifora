import '../entities/notification_settings.dart';
import '../repositories/notification_repository.dart';

class SaveNotificationSettings {
  SaveNotificationSettings(this._repository);

  final NotificationRepository _repository;

  Future<void> call(NotificationSettings settings) {
    return _repository.saveSettings(settings);
  }
}

