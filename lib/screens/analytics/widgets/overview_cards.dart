import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/app_theme.dart';
import '../../../providers/task_provider.dart';
import '../../../widgets/stats_card.dart';

class OverviewCards extends StatelessWidget {
  const OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                StatsCard(
                  title: 'Total Tasks',
                  value: '${taskProvider.tasks.length}',
                  icon: Icons.assignment,
                  color: AppTheme.primaryColor,
                ),
                StatsCard(
                  title: 'Completed',
                  value: '${taskProvider.completedTasks.length}',
                  icon: Icons.check_circle,
                  color: AppTheme.successColor,
                ),
                StatsCard(
                  title: 'In Progress',
                  value: '${taskProvider.inProgressTasks.length}',
                  icon: Icons.play_circle,
                  color: AppTheme.infoColor,
                ),
                StatsCard(
                  title: 'Overdue',
                  value: '${taskProvider.overdueTasks.length}',
                  icon: Icons.warning,
                  color: AppTheme.errorColor,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
