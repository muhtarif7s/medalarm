import 'package:flutter/foundation.dart';

class Notification {
  final int id;
  final String title;
  final String body;
  final DateTime? scheduledTime;

  Notification(this.id, this.title, this.body, this.scheduledTime);
}

class NotificationService {
  final List<Notification> _notifications = [];

  List<Notification> get notifications => _notifications;

  Future<void> init() async {
    // No-op
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    _notifications.add(Notification(id, title, body, scheduledTime));
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
  ) async {
    _notifications.add(Notification(id, title, body, null));
  }

  Future<void> cancelNotification(int id) async {
    _notifications.removeWhere((notification) => notification.id == id);
  }
}
