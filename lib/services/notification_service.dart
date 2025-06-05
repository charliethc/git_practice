import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class NotificationService {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleRepeating(
    int id,
    String title,
    String body,
    Duration repeatInterval,
  ) async {
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      const NotificationDetails(
        android: AndroidNotificationDetails('reminders', 'Reminders'),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // This is where background tasks would trigger notifications.
    return Future.value(true);
  });
}
