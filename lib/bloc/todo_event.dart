part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

final class TodoSearched extends TodoEvent {}

final class TodoCompleted extends TodoEvent {
  final TodoModel todo;

  const TodoCompleted({required this.todo});
}

final class TodoCreated extends TodoEvent {
  final TodoModel todo;

  const TodoCreated({required this.todo});
}
