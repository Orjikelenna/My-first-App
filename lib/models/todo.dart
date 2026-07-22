class Todo {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    this.createdAt,
  });

  factory Todo.fromFirestore(Map<String, dynamic> data, String id) {
    return Todo(
      id: id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt']?.toDate(),
    );
  }
}
