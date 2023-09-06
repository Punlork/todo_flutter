import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_bloc.dart';
import 'package:todo_app/model/todo_modal.dart';
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
    }
  }

  void completedTodo(TodoModel todo) {
    BlocProvider.of<TodoBloc>(context).add(TodoCompleted(todo: todo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text(
          "Todo App",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              onSubmitted: (_) => createTodo(),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffix: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: createTodo,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        "Add",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                      ),
                    ),
                  ),
                ),
                label: const Text("Add Todo"),
                hintText: 'Add your todo...',
              ),
            ),
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  log(state.toString());
                  switch (state.status) {
                    case TodoStatus.empty:
                      return const Center(
                        child: Text('No result. Create a new one instead.'),
                      );
                    case TodoStatus.initial:
                      if (state.todo.isEmpty) {}
                      return const Center(
                        child: Text('No result. Create a new one instead.'),
                      );
                    case TodoStatus.created:
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${state.todo.length} Todo Found",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  TextButton.icon(
                                    label: Text(
                                      "Delete",
                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: Colors.red,
                                          ),
                                    ),
                                    onPressed: () => {},
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                  TextButton.icon(
                                    label: Text(
                                      "Edit",
                                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            color: Colors.blue,
                                          ),
                                    ),
                                    onPressed: () => {},
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.todo.length,
                              itemBuilder: (context, index) {
                                final todo = state.todo[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    todo.description,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        'Status: ',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      Text(
                                        todo.isCompleted ? 'Completed' : 'Not yet started',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color:
                                                  todo.isCompleted ? Colors.green : Colors.orange,
                                            ),
                                      ),
                                    ],
                                  ),
                                  trailing: todo.isCompleted
                                      ? null
                                      : TextButton.icon(
                                          label: Text(
                                            "Mark as Completed",
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                  color: Colors.green,
                                                ),
                                          ),
                                          onPressed: () => completedTodo(todo),
                                          icon: const Icon(
                                            Icons.done,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
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
    );
  }
}
