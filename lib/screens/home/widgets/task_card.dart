import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed
                            ? theme.textTheme.bodyMedium?.color
                            : null,
                      ),
                    ),
                  ),
                  _buildPriorityIndicator(),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: task.status == TaskStatus.completed
                        ? theme.textTheme.bodyMedium?.color?.withOpacity(0.6)
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildCategoryChip(theme),
                  const SizedBox(width: 8),
                  _buildStatusChip(theme),
                  const Spacer(),
                  if (task.dueDate != null) _buildDueDateChip(theme),
                ],
              ),
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: task.tags
                      .take(3)
                      .map((tag) => _buildTagChip(tag, theme))
                      .toList(),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${task.estimatedMinutes} min',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onToggle,
                        icon: Icon(
                          task.status == TaskStatus.completed
                              ? Icons.undo
                              : task.status == TaskStatus.inProgress
                              ? Icons.check_circle
                              : Icons.play_circle_outline,
                          color: task.status == TaskStatus.completed
                              ? AppTheme.successColor
                              : AppTheme.primaryColor,
                        ),
                        tooltip: task.status == TaskStatus.completed
                            ? 'Mark as pending'
                            : task.status == TaskStatus.inProgress
                            ? 'Mark as completed'
                            : 'Start task',
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        color: AppTheme.errorColor,
                        tooltip: 'Delete task',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppTheme.getPriorityColor(task.priority),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCategoryChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.getCategoryColor(task.category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getCategoryColor(task.category).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        task.category.name.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppTheme.getCategoryColor(task.category),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.getStatusColor(task.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getStatusColor(task.status).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        task.status.name.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppTheme.getStatusColor(task.status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDueDateChip(ThemeData theme) {
    final isOverdue = task.isOverdue;
    final isDueToday = task.isDueToday;

    Color chipColor;
    if (isOverdue) {
      chipColor = AppTheme.errorColor;
    } else if (isDueToday) {
      chipColor = AppTheme.warningColor;
    } else {
      chipColor = AppTheme.infoColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.warning : Icons.schedule,
            size: 12,
            color: chipColor,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDueDate(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '#$tag',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  String _formatDueDate() {
    if (task.dueDate == null) return '';

    final now = DateTime.now();
    final due = task.dueDate!;
    final difference = due.difference(now).inDays;

    if (task.isOverdue) {
      return 'Overdue';
    } else if (task.isDueToday) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference <= 7) {
      return '${difference}d';
    } else {
      return DateFormat('MMM dd').format(due);
    }
  }
}
