import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:myapp/src/features/medication/data/models/medication.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezones
    tz.initializeTimeZones();
    final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).toString();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Configure Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configure iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestExactAlarmsPermission();
      await androidPlugin.requestNotificationsPermission();
    }

    final iOSPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iOSPlugin != null) {
      await iOSPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> scheduleNotifications(Medication medication, String title, String body) async {
    // 1. Cancel any existing notifications for this medication first
    await cancelNotifications(medication.id!); 

    // 2. Schedule new notifications based on the schedule type
    switch (medication.scheduleType) {
      case MedicationScheduleType.daily:
        _scheduleDailyNotifications(medication, title, body);
        break;
      case MedicationScheduleType.weekdays:
        _scheduleSpecificDaysNotifications(medication, title, body);
        break;
      case MedicationScheduleType.interval:
        _scheduleIntervalNotifications(medication, title, body);
        break;
    }
  }

  Future<void> cancelNotifications(int medicationId) async {
    // Cancel all notifications for a given medication ID.
    // We use a predictable range of IDs.
    for (int i = 0; i < 50; i++) { // Assuming max 50 notifications per medication
      await _notificationsPlugin.cancel(_generateNotificationId(medicationId, i));
    }
  }

  int _generateNotificationId(int medicationId, int index) {
    // Create a unique, predictable ID for each notification
    return (medicationId << 8) + index;
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time, {DateTime? after}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    if(after != null && scheduledDate.isBefore(after)){
        scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  void _scheduleDailyNotifications(Medication medication, String title, String body) {
    for (int i = 0; i < medication.times.length; i++) {
      final time = medication.times[i];
      final scheduledDate = _nextInstanceOfTime(time);
      
      if (_isWithinScheduleWindow(scheduledDate, medication)) {
        _notificationsPlugin.zonedSchedule(
          _generateNotificationId(medication.id!, i),
          title,
          body,
          scheduledDate,
          _notificationDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  }

  void _scheduleSpecificDaysNotifications(Medication medication, String title, String body) {
    if (medication.weekdays == null || medication.weekdays!.isEmpty) return;
    
    for (int i = 0; i < medication.times.length; i++) {
        final time = medication.times[i];

        for (int day in medication.weekdays!) {
            tz.TZDateTime scheduledDate = _nextInstanceOfTime(time);
            while (scheduledDate.weekday != day) {
                scheduledDate = scheduledDate.add(const Duration(days: 1));
            }
            
            if (_isWithinScheduleWindow(scheduledDate, medication)) {
              _notificationsPlugin.zonedSchedule(
                _generateNotificationId(medication.id!, i * 7 + day),
                title,
                body,
                scheduledDate,
                _notificationDetails(),
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
                matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
              );
            }
        }
    }
  }

  void _scheduleIntervalNotifications(Medication medication, String title, String body) {
    if (medication.interval == null) return;
    tz.TZDateTime nextNotificationTime = tz.TZDateTime.from(medication.startDate, tz.local);
    final now = tz.TZDateTime.now(tz.local);

    // Find the first upcoming notification time
    while (nextNotificationTime.isBefore(now)) {
      nextNotificationTime = nextNotificationTime.add(Duration(hours: medication.interval!));
    }

    // Schedule the next 20 occurrences to avoid infinite loops
    for (int i = 0; i < 20; i++) {
      if (_isWithinScheduleWindow(nextNotificationTime, medication)) {
          _notificationsPlugin.zonedSchedule(
            _generateNotificationId(medication.id!, i),
            title,
            body,
            nextNotificationTime,
            _notificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
      }
      nextNotificationTime = nextNotificationTime.add(Duration(hours: medication.interval!));
      if(medication.endDate != null && nextNotificationTime.isAfter(medication.endDate!)){
          break;
      }
    }
  }

  bool _isWithinScheduleWindow(tz.TZDateTime date, Medication medication) {
      if (date.isBefore(medication.startDate)) return false;
      if (medication.endDate != null && date.isAfter(medication.endDate!)) return false;
      return true;
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'medication_channel',
        'Medication Reminders',
        channelDescription: 'Channel for medication reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('res_notification_sound'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification_sound.aiff',
      ),
    );
  }
}
