import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';

class DetailsHeader extends StatelessWidget {
  final Task task;

  const DetailsHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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
}
