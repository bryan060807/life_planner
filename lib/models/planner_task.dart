import 'dart:convert';

import 'task_category.dart';

class PlannerTask {
  final String id;
  String title;
  bool isCompleted;
  DateTime createdAt;
  DateTime? dueDate;
  TaskCategory category;

  PlannerTask({
    String? id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
    this.dueDate,
    this.category = TaskCategory.inbox,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'category': taskCategoryToString(category),
    };
  }

  factory PlannerTask.fromJson(Map<String, dynamic> json) {
    return PlannerTask(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      dueDate: json['dueDate'] != null && json['dueDate'] != ''
          ? DateTime.tryParse(json['dueDate'])
          : null,
      category: json['category'] != null
          ? taskCategoryFromString(json['category'])
          : TaskCategory.inbox,
    );
  }

  PlannerTask copyWith({
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskCategory? category,
  }) {
    return PlannerTask(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}
