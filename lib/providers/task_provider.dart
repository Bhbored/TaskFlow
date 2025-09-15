import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  TaskCategory? _selectedCategory;
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;
  bool _showCompleted = true;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  TaskCategory? get selectedCategory => _selectedCategory;
  TaskStatus? get selectedStatus => _selectedStatus;
  TaskPriority? get selectedPriority => _selectedPriority;
  bool get showCompleted => _showCompleted;

  List<Task> get filteredTasks {
    return _tasks.where((task) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!task.title.toLowerCase().contains(query) &&
            !task.description.toLowerCase().contains(query) &&
            !task.tags.any((tag) => tag.toLowerCase().contains(query))) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null && task.category != _selectedCategory) {
        return false;
      }

      // Status filter
      if (_selectedStatus != null && task.status != _selectedStatus) {
        return false;
      }

      // Priority filter
      if (_selectedPriority != null && task.priority != _selectedPriority) {
        return false;
      }

      // Completed filter
      if (!_showCompleted && task.status == TaskStatus.completed) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Task> get pendingTasks =>
      _tasks.where((task) => task.status == TaskStatus.pending).toList();
  List<Task> get inProgressTasks =>
      _tasks.where((task) => task.status == TaskStatus.inProgress).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.completed).toList();
  List<Task> get overdueTasks =>
      _tasks.where((task) => task.isOverdue).toList();
  List<Task> get dueTodayTasks =>
      _tasks.where((task) => task.isDueToday).toList();

  Map<TaskCategory, int> get tasksByCategory {
    Map<TaskCategory, int> categoryCount = {};
    for (TaskCategory category in TaskCategory.values) {
      categoryCount[category] = _tasks
          .where((task) => task.category == category)
          .length;
    }
    return categoryCount;
  }

  Map<TaskPriority, int> get tasksByPriority {
    Map<TaskPriority, int> priorityCount = {};
    for (TaskPriority priority in TaskPriority.values) {
      priorityCount[priority] = _tasks
          .where((task) => task.priority == priority)
          .length;
    }
    return priorityCount;
  }

  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    final completed = _tasks
        .where((task) => task.status == TaskStatus.completed)
        .length;
    return completed / _tasks.length;
  }

  int get totalEstimatedTime {
    return _tasks
        .where((task) => task.status != TaskStatus.completed)
        .fold(0, (sum, task) => sum + task.estimatedMinutes);
  }

  Future<void> loadTasks() async {
    _isLoading = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString('tasks');

      if (tasksJson != null) {
        final List<dynamic> tasksList = json.decode(tasksJson);
        _tasks = tasksList.map((json) => Task.fromJson(json)).toList();
      } else {
        // Add some sample tasks for demonstration
        _addSampleTasks();
      }
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      _addSampleTasks();
    }

    _isLoading = false;
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = json.encode(
        _tasks.map((task) => task.toJson()).toList(),
      );
      await prefs.setString('tasks', tasksJson);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
    saveTasks();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
      saveTasks();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
    saveTasks();
  }

  void toggleTaskStatus(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      TaskStatus newStatus;
      DateTime? completedAt;

      switch (task.status) {
        case TaskStatus.pending:
          newStatus = TaskStatus.inProgress;
          break;
        case TaskStatus.inProgress:
          newStatus = TaskStatus.completed;
          completedAt = DateTime.now();
          break;
        case TaskStatus.completed:
          newStatus = TaskStatus.pending;
          break;
        case TaskStatus.cancelled:
          newStatus = TaskStatus.pending;
          break;
      }

      _tasks[index] = task.copyWith(
        status: newStatus,
        completedAt: completedAt,
      );
      notifyListeners();
      saveTasks();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedStatus(TaskStatus? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setSelectedPriority(TaskPriority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setShowCompleted(bool show) {
    _showCompleted = show;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _selectedStatus = null;
    _selectedPriority = null;
    _showCompleted = true;
    notifyListeners();
  }

  void _addSampleTasks() {
    _tasks = [
      Task(
        title: 'Complete Flutter project demo',
        description:
            'Create an impressive task management app showcasing Flutter skills',
        priority: TaskPriority.high,
        category: TaskCategory.work,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['flutter', 'demo', 'portfolio'],
        estimatedMinutes: 120,
      ),
      Task(
        title: 'Review React documentation',
        description: 'Study React hooks and modern patterns',
        priority: TaskPriority.medium,
        category: TaskCategory.education,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        tags: ['react', 'learning'],
        estimatedMinutes: 90,
      ),
      Task(
        title: 'Grocery shopping',
        description: 'Buy ingredients for weekend cooking',
        priority: TaskPriority.low,
        category: TaskCategory.personal,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        tags: ['shopping', 'food'],
        estimatedMinutes: 45,
      ),
      Task(
        title: 'Morning workout',
        description: '30-minute cardio session',
        priority: TaskPriority.medium,
        category: TaskCategory.health,
        status: TaskStatus.completed,
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['fitness', 'health'],
        estimatedMinutes: 30,
      ),
      Task(
        title: 'Update budget spreadsheet',
        description: 'Track monthly expenses and plan next month',
        priority: TaskPriority.high,
        category: TaskCategory.finance,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        tags: ['finance', 'budget'],
        estimatedMinutes: 60,
      ),
    ];
  }
}
