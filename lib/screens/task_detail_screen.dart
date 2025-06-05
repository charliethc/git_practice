import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../services/firestore_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final FirestoreService service;
  const TaskDetailScreen({super.key, required this.task, required this.service});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  void _toggleSubtask(int index, bool? value) {
    setState(() {
      _task.subtasks[index].done = value ?? false;
    });
    widget.service.saveTask(_task);
  }

  void _deleteSubtask(int index) {
    setState(() {
      _task.subtasks.removeAt(index);
    });
    widget.service.saveTask(_task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_task.title)),
      body: ListView.builder(
        itemCount: _task.subtasks.length,
        itemBuilder: (context, index) {
          final subtask = _task.subtasks[index];
          return Dismissible(
            key: ValueKey(subtask.title + index.toString()),
            onDismissed: (_) => _deleteSubtask(index),
            child: CheckboxListTile(
              title: Text(subtask.title),
              value: subtask.done,
              onChanged: (value) => _toggleSubtask(index, value),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = TextEditingController();
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Subtask'),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _task.subtasks.add(Subtask(title: controller.text));
                    });
                    widget.service.saveTask(_task);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
