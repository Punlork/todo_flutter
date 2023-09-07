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
  late final TextEditingController _searchController;
  late final TodoBloc todoBloc;

  @override
  void initState() {
    todoBloc = BlocProvider.of<TodoBloc>(context);
    _searchController = TextEditingController();
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
    final description = _textController.text;

    if (description.isNotEmpty) {
      final isDuplicate = todoBloc.state.todos.any((todo) => todo.description == description);
      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Duplicate todo. This todo already exists.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        const uuid = Uuid();
        final todo = TodoModel(
          id: uuid.v1(),
          description: _textController.text,
        );
        BlocProvider.of<TodoBloc>(context).add(TodoCreated(todo: todo));
      }
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: const Icon(Icons.search),
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

  void _onClearTapped() {
    setState(() {});
    todoBloc.add(const TodoSearched(keyword: ''));
    _searchController.text = '';
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {});
        todoBloc.add(TodoSearched(keyword: value));
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        suffixIcon: _searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: _onClearTapped,
                child: const Icon(Icons.clear),
              )
            : null,
        label: const Text("Search Todo"),
        hintText: 'Search your todo...',
      ),
    );
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
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              switch (state.status) {
                case TodoStatus.notFound:
                  return Column(
                    children: [
                      _buildSearch(),
                      const Expanded(
                        child: Center(
                          child: Text('No todo found. Search a new one instead.'),
                        ),
                      ),
                    ],
                  );
                case TodoStatus.initial:
                  return const Center(
                    child: Text('No result. Create a new one instead.'),
                  );

                case TodoStatus.created:
                  final buildLength = state.filteredTodos.isNotEmpty
                      ? state.filteredTodos.length
                      : state.todos.length;

                  final completedTodosLength = state.completedTodos.length;

                  return Column(
                    children: [
                      _buildSearch(),
                      const SizedBox(height: 20),
                      ListView.builder(
                        itemCount: buildLength,
                        itemBuilder: (context, index) {
                          final todo = state.filteredTodos.isNotEmpty
                              ? state.filteredTodos[index]
                              : state.todos[index];
                          return TodoWidget(
                            todo: todo,
                            onCompletedPressed: completedTodo,
                            onRemovedPressed: removedTodo,
                            onEditedPressed: editTodo,
                          );
                        },
                        shrinkWrap: true,
                      ),
                      state.completedTodos.isNotEmpty && state.filteredTodos.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Completed: $completedTodosLength ${completedTodosLength > 2 ? 'todos' : 'todo'}',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                ListView.builder(
                                  itemCount: completedTodosLength,
                                  itemBuilder: (context, index) {
                                    final todo = state.completedTodos[index];
                                    return TodoWidget(
                                      todo: todo,
                                      onCompletedPressed: completedTodo,
                                      onRemovedPressed: removedTodo,
                                      onEditedPressed: editTodo,
                                    );
                                  },
                                  shrinkWrap: true,
                                )
                              ],
                            )
                          : const SizedBox()
                    ],
                  );
                default:
                  return const Center(child: Text('Default'));
              }
            },
          ),
        ),
      ),
    );
  }
}
