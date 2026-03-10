class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json, String id) {
    return TaskModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
