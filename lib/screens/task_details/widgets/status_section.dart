import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';
import '../../../providers/task_provider.dart';

class StatusSection extends StatelessWidget {
  final Task task;

  const StatusSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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
}
