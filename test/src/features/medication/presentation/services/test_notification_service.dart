import 'package:flutter/material.dart';
import 'package:myapp/src/features/medication/presentation/services/notification_service.dart';

class TestNotificationService implements NotificationService {
  final List<Notification> scheduledNotifications = [];
  final List<Notification> shownNotifications = [];

  @override
  Future<void> init() async {
    // no-op
  }

  @override
  Future<void> requestPermissions() async {
    // no-op
  }

  @override
  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    scheduledNotifications.add(Notification(id, title, body, scheduledTime));
  }

  @override
  Future<void> showNotification(
    int id,
    String title,
    String body,
  ) async {
    shownNotifications.add(Notification(id, title, body, null));
  }

  @override
  Future<void> cancelNotification(int id) async {
    scheduledNotifications.removeWhere((notification) => notification.id == id);
  }

  void clear() {
    scheduledNotifications.clear();
    shownNotifications.clear();
  }
}

class Notification {
  final int id;
  final String title;
  final String body;
  final DateTime? scheduledTime;

  Notification(this.id, this.title, this.body, this.scheduledTime);
}
