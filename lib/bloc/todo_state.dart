part of 'todo_bloc.dart';

enum TodoStatus {
  initial,
  loading,
  created,
  notFound,
  empty,
  failed,
}

class TodoState extends Equatable {
  const TodoState({
    this.status = TodoStatus.initial,
    this.todos = const [],
    this.completedTodos = const [],
    this.filteredTodos = const [],
  });

  final TodoStatus status;
  final List<TodoModel> todos;
  final List<TodoModel> filteredTodos;
  final List<TodoModel> completedTodos;

  TodoState copyWith({
    TodoStatus? status,
    List<TodoModel>? todos,
    List<TodoModel>? filteredTodos,
    List<TodoModel>? completedTodos,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      completedTodos: completedTodos ?? this.completedTodos,
    );
  }

  @override
  List<Object> get props => [status, todos, filteredTodos, completedTodos];
}
