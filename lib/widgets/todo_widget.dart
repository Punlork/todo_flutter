import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_modal.dart';
import 'package:todo_app/widgets/custom_shadow_box.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({
    Key? key,
    required this.todo,
    required this.onCompletedPressed,
    required this.onRemovedPressed,
    required this.onEditedPressed,
  }) : super(key: key);

  final TodoModel todo;

  final void Function({
    required TodoModel todo,
    required bool value,
  }) onCompletedPressed;

  final void Function(String id) onRemovedPressed;
  final void Function(String description) onEditedPressed;

  PopupMenuItem<String> buildPopupMenuItem(String value, String text, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          CustomBoxShadow(
            color: Colors.white.withOpacity(.2),
            blurStyle: BlurStyle.outer,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: todo.isCompleted,
                onChanged: (value) => onCompletedPressed(
                  todo: todo,
                  value: value!,
                ),
                activeColor: Colors.green,
              ),
              Text(
                todo.description,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: PopupMenuButton<String>(
              itemBuilder: (context) => [
                buildPopupMenuItem('edit', 'Edit', Icons.edit),
                buildPopupMenuItem('delete', 'Delete', Icons.delete),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  onEditedPressed(todo.description);
                } else if (value == 'delete') {
                  onRemovedPressed(todo.id);
                }
              },
              child: const Icon(
                Icons.more_vert,
                size: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
