class NotificationService {
  bool _notificationsEnabled = true;

  bool areNotificationsEnabled() {
    return _notificationsEnabled;
  }

  void enableNotifications() {
    _notificationsEnabled = true;
  }

  void disableNotifications() {
    _notificationsEnabled = false;
  }
}
