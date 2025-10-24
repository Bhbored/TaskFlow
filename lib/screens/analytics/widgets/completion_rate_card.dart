import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/app_theme.dart';
import '../../../providers/task_provider.dart';
import '../../../widgets/stats_card.dart'; // Assuming ProgressStatsCard is in stats_card.dart

class CompletionRateCard extends StatelessWidget {
  const CompletionRateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return ProgressStatsCard(
          title: 'Completion Rate',
          progress: taskProvider.completionRate,
          progressText:
              '${taskProvider.completedTasks.length} of ${taskProvider.tasks.length} tasks completed',
          color: AppTheme.successColor,
        );
      },
    );
  }
}
