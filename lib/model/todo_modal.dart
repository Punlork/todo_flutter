class TodoModel {
  final String id;
  final String description;
  final bool isCompleted;

  TodoModel({
    required this.description,
    required this.id,
    this.isCompleted = false,
  });

  TodoModel copyWith({String? description, bool? isCompleted, String? id}) {
    return TodoModel(
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      id: id ?? this.id,
    );
  }
}
