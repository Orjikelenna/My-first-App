import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/todo.dart';

class TodoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user's todos collection
  CollectionReference get _todos => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('todos');

  // Add a todo
  Future<void> addTodo(String title) async {
    await _todos.add({
      'title': title,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Toggle todo completion
  Future<void> toggleTodo(String id, bool currentStatus) async {
    await _todos.doc(id).update({'isCompleted': !currentStatus});
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    await _todos.doc(id).delete();
  }

  // Stream of todos
  Stream<List<Todo>> getTodos() {
    return _todos.orderBy('createdAt').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
