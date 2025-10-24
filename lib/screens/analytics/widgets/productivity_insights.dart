import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/app_theme.dart';
import '../../../providers/task_provider.dart';

class ProductivityInsights extends StatelessWidget {
  const ProductivityInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final insights = _generateInsights(taskProvider);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productivity Insights',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...insights.map(
                  (insight) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(insight.icon, color: insight.color, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            insight.text,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Insight> _generateInsights(TaskProvider taskProvider) {
    final insights = <Insight>[];

    if (taskProvider.completionRate > 0.8) {
      insights.add(
        Insight(
          text: 'Great job! You have a high completion rate.',
          icon: Icons.emoji_events,
          color: AppTheme.successColor,
        ),
      );
    } else if (taskProvider.completionRate < 0.3) {
      insights.add(
        Insight(
          text: 'Consider breaking down large tasks into smaller ones.',
          icon: Icons.lightbulb,
          color: AppTheme.warningColor,
        ),
      );
    }

    if (taskProvider.overdueTasks.isNotEmpty) {
      insights.add(
        Insight(
          text:
              'You have ${taskProvider.overdueTasks.length} overdue tasks. Consider prioritizing them.',
          icon: Icons.warning,
          color: AppTheme.errorColor,
        ),
      );
    }

    if (taskProvider.dueTodayTasks.isNotEmpty) {
      insights.add(
        Insight(
          text:
              'You have ${taskProvider.dueTodayTasks.length} tasks due today.',
          icon: Icons.today,
          color: AppTheme.infoColor,
        ),
      );
    }

    final mostCommonCategory = taskProvider.tasksByCategory.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    if (mostCommonCategory.value > 0) {
      insights.add(
        Insight(
          text:
              'Most of your tasks are in the ${mostCommonCategory.key.name} category.',
          icon: Icons.category,
          color: AppTheme.getCategoryColor(mostCommonCategory.key),
        ),
      );
    }

    if (insights.isEmpty) {
      insights.add(
        Insight(
          text: 'Start adding tasks to see productivity insights!',
          icon: Icons.add_task,
          color: AppTheme.primaryColor,
        ),
      );
    }

    return insights;
  }
}

class Insight {
  final String text;
  final IconData icon;
  final Color color;

  Insight({required this.text, required this.icon, required this.color});
}
