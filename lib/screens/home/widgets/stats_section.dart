import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/task_provider.dart';
import '../../../models/app_theme.dart';
import '../../../widgets/stats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Container(
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'Total Tasks',
                  value: '${taskProvider.tasks.length}',
                  icon: Icons.assignment,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'Completed',
                  value: '${taskProvider.completedTasks.length}',
                  icon: Icons.check_circle,
                  color: AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'In Progress',
                  value: '${taskProvider.inProgressTasks.length}',
                  icon: Icons.play_circle,
                  color: AppTheme.infoColor,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'Overdue',
                  value: '${taskProvider.overdueTasks.length}',
                  icon: Icons.warning,
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}