import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/model/todo_modal.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<TodoCreated>(onTodoCreated);
    on<TodoCompleted>(onTodoCompleted);
    on<TodoDeleted>(onTodoDeleted);
  }

  FutureOr<void> onTodoCreated(
    TodoCreated event,
    Emitter<TodoState> emit,
  ) {
    try {
      final tempTodo = List<TodoModel>.from(state.todo);
      tempTodo.add(event.todo);
      emit(state.copyWith(
        status: TodoStatus.created,
        todo: tempTodo,
      ));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }

  FutureOr<void> onTodoCompleted(TodoCompleted event, Emitter<TodoState> emit) {
    try {
      final tempTodo = List<TodoModel>.from(state.todo);
      final index = tempTodo.indexWhere((element) => element.id == event.todo.id);
      if (index != -1) {
        tempTodo[index] = event.todo.copyWith(isCompleted: event.isChecked);
        emit(state.copyWith(
          status: TodoStatus.created,
          todo: tempTodo,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }

  FutureOr<void> onTodoDeleted(TodoDeleted event, Emitter<TodoState> emit) {
    try {
      final tempTodo = List<TodoModel>.from(state.todo);
      tempTodo.removeWhere((todo) => todo.id == event.id);
      emit(
        state.copyWith(
          status: TodoStatus.created,
          todo: tempTodo,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }
}
