import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';

class DetailsSection extends StatelessWidget {
  final Task task;

  const DetailsSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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
}
