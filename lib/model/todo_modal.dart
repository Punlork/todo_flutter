class TodoModel {
  final String id;
  final String description;
  final bool isCompleted;
  final bool isDeleteSelected;
  final bool isEditSelected;

  TodoModel({
    required this.description,
    required this.id,
    this.isCompleted = false,
    this.isEditSelected = false,
    this.isDeleteSelected = false,
  });

  TodoModel copyWith({
    String? description,
    bool? isCompleted,
    bool? isEditSelected,
    bool? isDeleteSelected,
    String? id,
  }) {
    return TodoModel(
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isEditSelected: isEditSelected ?? this.isEditSelected,
      isDeleteSelected: isDeleteSelected ?? this.isDeleteSelected,
      id: id ?? this.id,
    );
  }
}
