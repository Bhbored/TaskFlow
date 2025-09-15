import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/app_theme.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(task: task),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Edit task',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildStatusSection(context),
            const SizedBox(height: 24),
            _buildDetailsSection(context),
            const SizedBox(height: 24),
            _buildTagsSection(context),
            const SizedBox(height: 24),
            _buildActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      decoration: task.status == TaskStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                _buildPriorityIndicator(),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(task.description, style: theme.textTheme.bodyLarge),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.getPriorityColor(task.priority).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.getPriorityColor(task.priority),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.getPriorityColor(task.priority),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            task.priority.name.toUpperCase(),
            style: TextStyle(
              color: AppTheme.getPriorityColor(task.priority),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.getStatusColor(
                      task.status,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.getStatusColor(task.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    task.status.name.toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.getStatusColor(task.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Consumer<TaskProvider>(
                  builder: (context, taskProvider, child) {
                    return ElevatedButton.icon(
                      onPressed: () {
                        taskProvider.toggleTaskStatus(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              task.status == TaskStatus.completed
                                  ? 'Task marked as pending'
                                  : task.status == TaskStatus.inProgress
                                  ? 'Task marked as completed'
                                  : 'Task started',
                            ),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      },
                      icon: Icon(
                        task.status == TaskStatus.completed
                            ? Icons.undo
                            : task.status == TaskStatus.inProgress
                            ? Icons.check_circle
                            : Icons.play_circle_outline,
                      ),
                      label: Text(
                        task.status == TaskStatus.completed
                            ? 'Mark Pending'
                            : task.status == TaskStatus.inProgress
                            ? 'Mark Complete'
                            : 'Start Task',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              Icons.category,
              'Category',
              task.category.name.toUpperCase(),
              AppTheme.getCategoryColor(task.category),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.access_time,
              'Estimated Time',
              '${task.estimatedMinutes} minutes',
              AppTheme.infoColor,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              Icons.calendar_today,
              'Created',
              DateFormat('MMM dd, yyyy').format(task.createdAt),
              AppTheme.primaryColor,
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                Icons.schedule,
                'Due Date',
                DateFormat('MMM dd, yyyy').format(task.dueDate!),
                task.isOverdue ? AppTheme.errorColor : AppTheme.warningColor,
              ),
            ],
            if (task.completedAt != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                Icons.check_circle,
                'Completed',
                DateFormat('MMM dd, yyyy').format(task.completedAt!),
                AppTheme.successColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    final theme = Theme.of(context);

    if (task.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tags', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: task.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '#$tag',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Actions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskScreen(task: task),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Task'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteDialog(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                      side: BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task deleted successfully!'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
