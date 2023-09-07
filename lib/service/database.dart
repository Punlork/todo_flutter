import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/model/todo_modal.dart';

class FirebaseDB {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("todos/");

  // Add this method to retrieve todos
  Future<List<TodoModel>> getTodos() async {
    try {
      DataSnapshot snapshot = await _ref.get();
      if (snapshot.exists) {
        log(snapshot.value.toString());
        // Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;
        final data = Map<String, dynamic>.from(
          snapshot.value as Map<Object?, Object?>,
        );
        List<TodoModel> todos = [];
        data.forEach((key, value) {
          todos.add(
            TodoModel(
                key: key,
                description: value['description'],
                id: value['id'],
                isCompleted: value['isCompleted']),
          );
        });
        return todos;
      } else {
        return [];
      }
    } catch (error) {
      log("Error fetching todos: $error");
      rethrow;
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      final String? newTodoKey = _ref.push().key;

      final Map<String, dynamic> todoData = {
        'description': todo.description,
        'timestamp': ServerValue.timestamp,
        'isCompleted': todo.isCompleted,
        'id': todo.id,
      };

      await _ref.child(newTodoKey!).set(todoData);
    } catch (error) {
      log("Error adding todo: $error");
      rethrow;
    }
  }
}
