class Subtask {
  String title;
  bool done;

  Subtask({required this.title, this.done = false});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'done': done,
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      title: map['title'] ?? '',
      done: map['done'] ?? false,
    );
  }
}
