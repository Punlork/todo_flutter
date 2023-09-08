class TodoModel {
  final String id;
  final String description;
  final bool isCompleted;
  final bool isDeleteSelected;
  final bool isEditSelected;
  final String key;

  TodoModel({
    required this.description,
    required this.id,
    this.key = '',
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
    String? key,
  }) {
    return TodoModel(
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isEditSelected: isEditSelected ?? this.isEditSelected,
      isDeleteSelected: isDeleteSelected ?? this.isDeleteSelected,
      id: id ?? this.id,
      key: key ?? this.key,
    );
  }

  factory TodoModel.fromRTDB(String key, Map<String, dynamic> data) {
    return TodoModel(
      description: data['description'],
      id: data['description'],
      isCompleted: data['isCompleted'],
      key: key,
    );
  }
}
