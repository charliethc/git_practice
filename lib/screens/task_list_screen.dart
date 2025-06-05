import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';

class TaskListScreen extends StatelessWidget {
  final FirestoreService service;
  const TaskListScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Task>>(
      stream: service.tasksStream(),
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? [];
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ListTile(
              title: Text(task.title),
              subtitle: Text(task.urgency.name),
              trailing: Checkbox(
                value: task.completed,
                onChanged: (_) {
                  service.saveTask(
                    Task(
                      id: task.id,
                      title: task.title,
                      urgency: task.urgency,
                      completed: !task.completed,
                      subtasks: task.subtasks,
                    ),
                  );
                },
              ),
              onTap: () {},
            );
          },
        );
      },
    );
  }
}
