import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/app_theme.dart';
import '../providers/task_provider.dart';

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
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildPrioritySelector(),
            const SizedBox(height: 16),
            _buildDueDateSelector(),
            const SizedBox(height: 16),
            _buildEstimatedTimeField(),
            const SizedBox(height: 16),
            _buildTagsField(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'Task Title',
        hintText: 'Enter task title',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a task title';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter task description (optional)',
        prefixIcon: Icon(Icons.description),
      ),
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TaskCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return FilterChip(
              label: Text(category.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: AppTheme.getCategoryColor(
                category,
              ).withOpacity(0.2),
              checkmarkColor: AppTheme.getCategoryColor(category),
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: AppTheme.getCategoryColor(category),
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TaskPriority.values.map((priority) {
            final isSelected = _selectedPriority == priority;
            return FilterChip(
              label: Text(priority.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
              selectedColor: AppTheme.getPriorityColor(
                priority,
              ).withOpacity(0.2),
              checkmarkColor: AppTheme.getPriorityColor(priority),
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: AppTheme.getPriorityColor(priority),
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDueDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDueDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(
                  _selectedDueDate != null
                      ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                      : 'Select due date (optional)',
                  style: TextStyle(
                    color: _selectedDueDate != null ? null : Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (_selectedDueDate != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedDueDate = null;
                      });
                    },
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear due date',
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEstimatedTimeField() {
    return TextFormField(
      controller: _estimatedMinutesController,
      decoration: const InputDecoration(
        labelText: 'Estimated Time (minutes)',
        hintText: '30',
        prefixIcon: Icon(Icons.access_time),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter estimated time';
        }
        final minutes = int.tryParse(value);
        if (minutes == null || minutes <= 0) {
          return 'Please enter a valid number of minutes';
        }
        return null;
      },
    );
  }

  Widget _buildTagsField() {
    return TextFormField(
      controller: _tagsController,
      decoration: const InputDecoration(
        labelText: 'Tags',
        hintText: 'work, urgent, project (comma separated)',
        prefixIcon: Icon(Icons.tag),
      ),
      textCapitalization: TextCapitalization.none,
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveTask,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              widget.task != null ? 'Update Task' : 'Create Task',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDueDate = date;
      });
    }
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
