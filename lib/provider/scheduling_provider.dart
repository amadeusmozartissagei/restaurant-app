import 'package:flutter/material.dart';
import '../data/preferences/preferences_helper.dart';
import '../utils/notification_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  SchedulingProvider({required this.preferencesHelper}) {
    _getDailyReminderPreference();
  }

  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  void _getDailyReminderPreference() async {
    _isScheduled = await preferencesHelper.isDailyReminderActive;
    if (_isScheduled) {
      await NotificationHelper()
          .initNotifications(flutterLocalNotificationsPlugin);
      await NotificationHelper()
          .scheduleDaily11AM(flutterLocalNotificationsPlugin);
    }
    notifyListeners();
  }

  Future<bool> scheduledNews(bool value) async {
    _isScheduled = value;
    preferencesHelper.setDailyReminder(value);

    if (_isScheduled) {
      await NotificationHelper()
          .initNotifications(flutterLocalNotificationsPlugin);
      await NotificationHelper()
          .scheduleDaily11AM(flutterLocalNotificationsPlugin);
    } else {
      await flutterLocalNotificationsPlugin.cancelAll();
    }
    notifyListeners();
    return _isScheduled;
  }
}
