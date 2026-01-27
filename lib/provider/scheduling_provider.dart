import 'package:flutter/material.dart';
import '../data/preferences/preferences_helper.dart';
import '../utils/notification_helper.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'; // Just in case, though utilizing local_notifications directly

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
       await NotificationHelper().initNotifications(flutterLocalNotificationsPlugin);
       await NotificationHelper().scheduleDaily11AM(flutterLocalNotificationsPlugin);
    }
    notifyListeners();
  }

  Future<bool> scheduledNews(bool value) async {
    _isScheduled = value;
    preferencesHelper.setDailyReminder(value);
    
    if (_isScheduled) {
      print('Scheduling Activated');
      await NotificationHelper().initNotifications(flutterLocalNotificationsPlugin);
      await NotificationHelper().scheduleDaily11AM(flutterLocalNotificationsPlugin);
    } else {
      print('Scheduling Canceled');
      await flutterLocalNotificationsPlugin.cancelAll();
    }
    notifyListeners();
    return _isScheduled;
  }
}
