import 'subtask.dart';

enum Urgency { normal, urgent, superImportant }

class Task {
  String id;
  String title;
  Urgency urgency;
  bool completed;
  List<Subtask> subtasks;

  Task({
    required this.id,
    required this.title,
    this.urgency = Urgency.normal,
    this.completed = false,
    this.subtasks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'urgency': urgency.index,
      'completed': completed,
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
    };
  }

  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      urgency: Urgency.values[map['urgency'] ?? 0],
      completed: map['completed'] ?? false,
      subtasks: (map['subtasks'] as List<dynamic>? ?? [])
          .map((e) => Subtask.fromMap(e))
          .toList(),
    );
  }
}
