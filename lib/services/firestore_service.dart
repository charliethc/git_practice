import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  String newId() {
    return _db.collection('tasks').doc().id;
  }

  Stream<List<Task>> tasksStream() {
    return _db.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> saveTask(Task task) {
    return _db.collection('tasks').doc(task.id).set(task.toMap());
  }

  Future<void> deleteTask(String id) {
    return _db.collection('tasks').doc(id).delete();
  }
}
