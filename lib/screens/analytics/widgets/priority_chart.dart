import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';
import '../../../providers/task_provider.dart';

class PriorityChart extends StatelessWidget {
  const PriorityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
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
      },
    );
  }
}
