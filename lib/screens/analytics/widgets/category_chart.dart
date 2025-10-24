import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';
import '../../../providers/task_provider.dart';

class CategoryChart extends StatelessWidget {
  const CategoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
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
      },
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
}
