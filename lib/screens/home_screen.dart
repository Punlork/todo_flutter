import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/model/todo_modal.dart';
import 'package:todo_app/widgets/fab.dart';
import 'package:todo_app/widgets/todo_widget.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  void completedTodo({required TodoModel todo, required bool value}) {
    BlocProvider.of<TodoBloc>(context).add(TodoCompleted(
      todo: todo,
      isChecked: value,
    ));
  }

  void removedTodo(String id) {
    BlocProvider.of<TodoBloc>(context).add(TodoDeleted(id: id));
  }

  void createTodo() {
    if (_textController.text.isNotEmpty) {
      const uuid = Uuid();
      final todo = TodoModel(
        id: uuid.v1(),
        description: _textController.text,
      );
      BlocProvider.of<TodoBloc>(context).add(TodoCreated(todo: todo));
      _textController.clear();
      Navigator.pop(context);
    }
  }

  void editTodo(TodoModel todo) {
    _textController.text = todo.description;
    onFABPressed(() {
      final tempTodo = todo.copyWith(description: _textController.text);
      BlocProvider.of<TodoBloc>(context).add(TodoEdited(todo: tempTodo));
      Navigator.pop(context);
    });
  }

  void onFABPressed(VoidCallback onSubmitted) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            right: 20,
            top: 20,
            left: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: TextField(
            controller: _textController,
            onSubmitted: (_) => onSubmitted(),
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              suffixIcon: IconButton(
                onPressed: onSubmitted,
                icon: const Icon(Icons.keyboard_double_arrow_up_outlined),
              ),
              label: const Text("Add Todo"),
              hintText: 'Add your todo...',
            ),
          ),
        );
      },
    ).whenComplete(() => _textController.clear());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFAB(
        onPressed: onFABPressed,
        onCreated: createTodo,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case TodoStatus.notFound:
                        return const Center(
                          child: Text('No result. Create a new one instead.'),
                        );
                      case TodoStatus.initial:
                        return const Center(
                          child: Text('No result. Create a new one instead.'),
                        );
                      case TodoStatus.created:
                        if (state.todo.isEmpty) {
                          return const Center(
                            child: Text('No result. Create a new one instead.'),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.todo.length,
                          itemBuilder: (context, index) {
                            final todo = state.todo[index];
                            return TodoWidget(
                              todo: todo,
                              onCompletedPressed: completedTodo,
                              onRemovedPressed: removedTodo,
                              onEditedPressed: editTodo,
                            );
                          },
                        );
                      default:
                        return const Center(child: Text('Default'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
