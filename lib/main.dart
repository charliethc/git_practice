import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/urgency_setting.dart';
import 'models/task.dart';
import 'services/firestore_service.dart';
import 'services/notification_service.dart';
import 'screens/task_list_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(ReminderApp(notificationService: notificationService));
}

class ReminderApp extends StatefulWidget {
  final NotificationService notificationService;
  const ReminderApp({super.key, required this.notificationService});
  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  final FirestoreService _service = FirestoreService();
  late final NotificationService _notifications;

  final Map<Urgency, UrgencySetting> _urgency = {
    Urgency.normal: UrgencySetting(60),
    Urgency.urgent: UrgencySetting(30),
    Urgency.superImportant: UrgencySetting(5),
  };

  @override
  void initState() {
    super.initState();
    _notifications = widget.notificationService;
  }

  Future<void> _addTask() async {
    final titleController = TextEditingController();
    Urgency urgency = Urgency.normal;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController),
              DropdownButton<Urgency>(
                value: urgency,
                onChanged: (value) => setState(() {
                  urgency = value ?? Urgency.normal;
                }),
                items: Urgency.values
                    .map(
                      (u) => DropdownMenuItem(
                        value: u,
                        child: Text(u.name),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final id = _service.newId();
                final task = Task(id: id, title: titleController.text, urgency: urgency);
                await _service.saveTask(task);
                final minutes = _urgency[urgency]?.minutes ?? 60;
                await _notifications.scheduleRepeating(
                  id.hashCode,
                  task.title,
                  'Reminder',
                  Duration(minutes: minutes),
                );
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

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
        floatingActionButton: FloatingActionButton(
          onPressed: _addTask,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
