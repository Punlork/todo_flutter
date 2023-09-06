import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    super.key,
    required this.onPressed,
    required this.onCreated,
  });

  final Function(VoidCallback) onPressed;
  final VoidCallback onCreated;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(onCreated),
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }
}
