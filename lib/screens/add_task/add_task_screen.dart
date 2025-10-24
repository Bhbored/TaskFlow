import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../models/app_theme.dart';
import '../../providers/task_provider.dart';
import 'widgets/title_field.dart';
import 'widgets/description_field.dart';
import 'widgets/category_selector.dart';
import 'widgets/priority_selector.dart';
import 'widgets/due_date_selector.dart';
import 'widgets/estimated_time_field.dart';
import 'widgets/tags_field.dart';
import 'widgets/save_button.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedMinutesController = TextEditingController();
  final _tagsController = TextEditingController();

  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskCategory _selectedCategory = TaskCategory.personal;
  DateTime? _selectedDueDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final task = widget.task!;
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _estimatedMinutesController.text = task.estimatedMinutes.toString();
    _tagsController.text = task.tags.join(', ');
    _selectedPriority = task.priority;
    _selectedCategory = task.category;
    _selectedDueDate = task.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedMinutesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _deleteTask,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete task',
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TitleField(controller: _titleController),
            const SizedBox(height: 16),
            DescriptionField(controller: _descriptionController),
            const SizedBox(height: 16),
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 16),
            PrioritySelector(
              selectedPriority: _selectedPriority,
              onPrioritySelected: (priority) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
            ),
            const SizedBox(height: 16),
            DueDateSelector(
              selectedDueDate: _selectedDueDate,
              onDueDateSelected: (date) {
                setState(() {
                  _selectedDueDate = date;
                });
              },
            ),
            const SizedBox(height: 16),
            EstimatedTimeField(controller: _estimatedMinutesController),
            const SizedBox(height: 16),
            TagsField(controller: _tagsController),
            const SizedBox(height: 32),
            SaveButton(
              isLoading: _isLoading,
              isEditing: isEditing,
              onPressed: _saveTask,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      final task = Task(
        id: widget.task?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDueDate,
        tags: tags,
        estimatedMinutes: int.parse(_estimatedMinutesController.text),
        status: widget.task?.status ?? TaskStatus.pending,
        createdAt: widget.task?.createdAt,
        completedAt: widget.task?.completedAt,
      );

      if (widget.task != null) {
        context.read<TaskProvider>().updateTask(task);
      } else {
        context.read<TaskProvider>().addTask(task);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.task != null
                  ? 'Task updated successfully!'
                  : 'Task created successfully!',
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.task != null) {
      context.read<TaskProvider>().deleteTask(widget.task!.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task deleted successfully!'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
