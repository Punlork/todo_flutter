import 'package:flutter/material.dart';

class TodoHeaderWidget extends StatelessWidget {
  const TodoHeaderWidget({
    Key? key,
    required this.onDeletePressed,
    required this.onEditPressed,
    required this.amount,
  }) : super(key: key);

  final VoidCallback onDeletePressed;
  final VoidCallback onEditPressed;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$amount Todo(s) Found",
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
              onPressed: onDeletePressed,
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
              onPressed: onEditPressed,
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
