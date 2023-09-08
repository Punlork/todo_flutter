import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/model/todo_modal.dart';

class FirebaseDB {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref("todos/");

  Future<List<TodoModel>> getTodos() async {
    try {
      DataSnapshot snapshot = await _ref.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(
          snapshot.value as Map<Object?, Object?>,
        );
        List<TodoModel> todos = [];
        data.forEach((key, value) {
          final todo = Map<String, dynamic>.from(
            value as Map<Object?, Object?>,
          );
          todos.add(TodoModel.fromRTDB(key, todo));
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

  void updateTodo({
    required TodoModel todo,
    bool? isCompleted,
    String? description,
  }) async {
    try {
      log(todo.key);
      DatabaseReference todoRef = _ref.child(todo.key);

      Map<String, dynamic> updatedData = {};

      if (isCompleted != null) {
        updatedData["isCompleted"] = isCompleted;
      }

      if (description != null) {
        updatedData["description"] = description;
      }

      await todoRef.update(updatedData);
    } catch (error) {
      log('Error updating todo status: $error');
      rethrow;
    }
  }

  void deleteTodo({
    required TodoModel todo,
  }) async {
    try {
      DatabaseReference todoRef = _ref.child(todo.key);

      await todoRef.remove();
    } catch (error) {
      log('Error updating todo status: $error');
      rethrow;
    }
  }

  Future<void> addTodo(TodoModel todo) async {
    try {
      // final String? newTodoKey = _ref.push().key;

      final Map<String, dynamic> todoData = {
        'description': todo.description,
        'timestamp': ServerValue.timestamp,
        'isCompleted': todo.isCompleted,
        'id': todo.id,
      };

      await _ref.child(todo.id).set(todoData);
    } catch (error) {
      log("Error adding todo: $error");
      rethrow;
    }
  }
}
