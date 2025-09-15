import 'package:uuid/uuid.dart';

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { pending, inProgress, completed, cancelled }

enum TaskCategory { work, personal, health, finance, education, other }

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final TaskCategory category;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final List<String> tags;
  final int estimatedMinutes;

  Task({
    String? id,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.category = TaskCategory.personal,
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
    this.tags = const [],
    this.estimatedMinutes = 30,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    TaskCategory? category,
    DateTime? dueDate,
    DateTime? completedAt,
    List<String>? tags,
    int? estimatedMinutes,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'status': status.index,
      'category': category.index,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'tags': tags,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      priority: TaskPriority.values[json['priority']],
      status: TaskStatus.values[json['status']],
      category: TaskCategory.values[json['category']],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      tags: List<String>.from(json['tags'] ?? []),
      estimatedMinutes: json['estimatedMinutes'] ?? 30,
    );
  }

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final due = dueDate!;
    return now.year == due.year && now.month == due.month && now.day == due.day;
  }

  Duration? get timeUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now());
  }
}
