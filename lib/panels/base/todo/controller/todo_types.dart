enum TodoPriority { Low, Medium, High }

enum TodoFilter { All, Active, Completed }

class TodoItem {
  const TodoItem({
    required this.Id,
    required this.Title,
    required this.Notes,
    required this.Priority,
    required this.IsCompleted,
    required this.CreatedAt,
    required this.UpdatedAt,
  });

  final String Id;
  final String Title;
  final String Notes;
  final TodoPriority Priority;
  final bool IsCompleted;
  final DateTime CreatedAt;
  final DateTime UpdatedAt;

  TodoItem CopyWith({
    String? Title,
    String? Notes,
    TodoPriority? Priority,
    bool? IsCompleted,
    DateTime? UpdatedAt,
  }) {
    return TodoItem(
      Id: Id,
      Title: Title ?? this.Title,
      Notes: Notes ?? this.Notes,
      Priority: Priority ?? this.Priority,
      IsCompleted: IsCompleted ?? this.IsCompleted,
      CreatedAt: CreatedAt,
      UpdatedAt: UpdatedAt ?? this.UpdatedAt,
    );
  }

  Map<String, Object?> ToJson() {
    return <String, Object?>{
      'id': Id,
      'title': Title,
      'notes': Notes,
      'priority': Priority.name,
      'isCompleted': IsCompleted,
      'createdAt': CreatedAt.toIso8601String(),
      'updatedAt': UpdatedAt.toIso8601String(),
    };
  }

  factory TodoItem.FromJson(Map<String, Object?> Json) {
    return TodoItem(
      Id: Json['id']! as String,
      Title: Json['title']! as String,
      Notes: Json['notes'] as String? ?? '',
      Priority: TodoPriority.values.firstWhere(
        (TodoPriority Value) => Value.name == Json['priority'],
        orElse: () => TodoPriority.Medium,
      ),
      IsCompleted: Json['isCompleted'] as bool? ?? false,
      CreatedAt: DateTime.parse(Json['createdAt']! as String),
      UpdatedAt: DateTime.parse(Json['updatedAt']! as String),
    );
  }
}
