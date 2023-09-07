import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:todo_app/model/todo_modal.dart';
import 'package:todo_app/service/database.dart';

part 'todo_event.dart';
part 'todo_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<TodoCreated>(onTodoCreated);
    on<TodoCompleted>(onTodoCompleted);
    on<TodoDeleted>(onTodoDeleted);
    on<TodoEdited>(onTodoEdited);
    on<TodoSearched>(onTodoSearched, transformer: debounce(_duration));
  }

  final firebaseDB = FirebaseDB();

  FutureOr<void> onTodoCreated(
    TodoCreated event,
    Emitter<TodoState> emit,
  ) async {
    try {
      final tempTodos = List<TodoModel>.from(state.todos);

      tempTodos.add(event.todo);
      emit(state.copyWith(
        status: TodoStatus.created,
        todos: tempTodos,
      ));
      await firebaseDB.addTodo(event.todo);
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }

  FutureOr<void> onTodoCompleted(TodoCompleted event, Emitter<TodoState> emit) {
    try {
      final tempTodos = List<TodoModel>.from(state.todos);
      final tempCompletedTodos = List<TodoModel>.from(state.completedTodos);

      final index = tempTodos.indexWhere((element) => element.id == event.todo.id);
      final completedIndex =
          tempCompletedTodos.indexWhere((element) => element.id == event.todo.id);

      if (event.isChecked) {
        if (index != -1) {
          final completedTodo = tempTodos.removeAt(index);
          tempCompletedTodos.add(completedTodo.copyWith(isCompleted: true));
        }
      } else {
        if (completedIndex != -1) {
          final notCompletedTodo = tempCompletedTodos.removeAt(completedIndex);
          tempTodos.add(
            notCompletedTodo.copyWith(isCompleted: false),
          );
        }
      }

      emit(
        state.copyWith(
          status: TodoStatus.created,
          todos: tempTodos,
          completedTodos: tempCompletedTodos,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }

  FutureOr<void> onTodoDeleted(TodoDeleted event, Emitter<TodoState> emit) {
    try {
      final tempTodos = List<TodoModel>.from(state.todos);
      tempTodos.removeWhere((todo) => todo.id == event.id);
      emit(
        state.copyWith(
          status: TodoStatus.created,
          todos: tempTodos,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }

  FutureOr<void> onTodoEdited(TodoEdited event, Emitter<TodoState> emit) {
    try {
      final tempTodos = List<TodoModel>.from(state.todos);
      final index = tempTodos.indexWhere((element) => element.id == event.todo.id);
      if (index != -1) {
        tempTodos[index] = event.todo.copyWith(description: event.todo.description);
        emit(state.copyWith(
          status: TodoStatus.created,
          todos: tempTodos,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }

  FutureOr<void> onTodoSearched(TodoSearched event, Emitter<TodoState> emit) {
    try {
      final searchTerm = event.keyword.toLowerCase();

      final List<TodoModel> combinedTodos = [...state.completedTodos, ...state.todos];

      final List<TodoModel> filteredTodo = combinedTodos.where((todo) {
        return todo.description.toLowerCase().contains(searchTerm);
      }).toList();

      if (searchTerm.isEmpty) {
        emit(
          state.copyWith(
            status: TodoStatus.created,
            todos: state.todos,
            filteredTodos: [],
          ),
        );
      } else {
        if (filteredTodo.isEmpty) {
          emit(state.copyWith(status: TodoStatus.notFound));
        } else {
          emit(
            state.copyWith(
              status: TodoStatus.created,
              filteredTodos: filteredTodo,
            ),
          );
        }
      }
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failed));
    }
  }
}
