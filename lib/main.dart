import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/urgency_setting.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';
import 'screens/task_list_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(ReminderApp());
}

class ReminderApp extends StatefulWidget {
  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  final FirestoreService _service = FirestoreService();

  final Map<String, UrgencySetting> _urgency = {
    'Normal': UrgencySetting(60),
    'Urgent': UrgencySetting(30),
    'Super Important': UrgencySetting(5),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tasks'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingsScreen(
                      settings: _urgency,
                      onChanged: (key, minutes) {
                        setState(() {
                          _urgency[key] = UrgencySetting(minutes);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: TaskListScreen(service: _service),
      ),
    );
  }
}
