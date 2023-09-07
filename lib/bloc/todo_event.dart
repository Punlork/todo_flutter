part of 'todo_bloc.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

final class TodoSearched extends TodoEvent {
  final String keyword;

  const TodoSearched({required this.keyword});
}

final class TodoEdited extends TodoEvent {
  final TodoModel todo;

  const TodoEdited({required this.todo});
}

final class TodoDeleted extends TodoEvent {
  final String id;

  const TodoDeleted({required this.id});
}

final class TodoCompleted extends TodoEvent {
  final TodoModel todo;
  final bool isChecked;

  const TodoCompleted({required this.todo, this.isChecked = false});
}

final class TodoCreated extends TodoEvent {
  final TodoModel todo;

  const TodoCreated({
    required this.todo,
  });
}
