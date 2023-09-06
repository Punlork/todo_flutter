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
    this.todo = const [],
  });

  final TodoStatus status;
  final List<TodoModel> todo;

  TodoState copyWith({
    TodoStatus? status,
    List<TodoModel>? todo,
  }) {
    return TodoState(
      status: status ?? this.status,
      todo: todo ?? this.todo,
    );
  }

  @override
  List<Object> get props => [status, todo];
}
