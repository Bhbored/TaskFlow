import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/task.dart';
import '../models/app_theme.dart';
import '../providers/task_provider.dart';
import '../widgets/stats_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCards(context, taskProvider),
                const SizedBox(height: 24),
                _buildCompletionRateCard(context, taskProvider),
                const SizedBox(height: 24),
                _buildCategoryChart(context, taskProvider),
                const SizedBox(height: 24),
                _buildPriorityChart(context, taskProvider),
                const SizedBox(height: 24),
                _buildTimeEstimationCard(context, taskProvider),
                const SizedBox(height: 24),
                _buildProductivityInsights(context, taskProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, TaskProvider taskProvider) {
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
  }

  Widget _buildCompletionRateCard(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    return ProgressStatsCard(
      title: 'Completion Rate',
      progress: taskProvider.completionRate,
      progressText:
          '${taskProvider.completedTasks.length} of ${taskProvider.tasks.length} tasks completed',
      color: AppTheme.successColor,
    );
  }

  Widget _buildCategoryChart(BuildContext context, TaskProvider taskProvider) {
    final categoryData = taskProvider.tasksByCategory;
    final chartData = categoryData.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => PieChartSectionData(
            color: AppTheme.getCategoryColor(entry.key),
            value: entry.value.toDouble(),
            title: '${entry.value}',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasks by Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: chartData.isEmpty
                  ? Center(
                      child: Text(
                        'No data available',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : PieChart(
                      PieChartData(
                        sections: chartData,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            _buildCategoryLegend(context, categoryData),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLegend(
    BuildContext context,
    Map<TaskCategory, int> categoryData,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: categoryData.entries
          .where((entry) => entry.value > 0)
          .map(
            (entry) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.getCategoryColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  entry.key.name.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildPriorityChart(BuildContext context, TaskProvider taskProvider) {
    final priorityData = taskProvider.tasksByPriority;
    final chartData = priorityData.entries
        .where((entry) => entry.value > 0)
        .map(
          (entry) => BarChartGroupData(
            x: entry.key.index,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: AppTheme.getPriorityColor(entry.key),
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        )
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasks by Priority',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: chartData.isEmpty
                  ? Center(
                      child: Text(
                        'No data available',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: priorityData.values.isEmpty
                            ? 10
                            : priorityData.values
                                      .reduce((a, b) => a > b ? a : b)
                                      .toDouble() +
                                  2,
                        barGroups: chartData,
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() <
                                    TaskPriority.values.length) {
                                  return Text(
                                    TaskPriority.values[value.toInt()].name
                                        .toUpperCase(),
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeEstimationCard(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    final totalMinutes = taskProvider.totalEstimatedTime;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Estimation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: AppTheme.infoColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining Tasks',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hours > 0
                            ? '$hours hours $minutes minutes'
                            : '$minutes minutes',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppTheme.infoColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Estimated time to complete all pending tasks',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityInsights(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
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
