import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import 'widgets/overview_cards.dart';
import 'widgets/completion_rate_card.dart';
import 'widgets/category_chart.dart';
import 'widgets/priority_chart.dart';
import 'widgets/time_estimation_card.dart';
import 'widgets/productivity_insights.dart';

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
                const OverviewCards(),
                const SizedBox(height: 24),
                const CompletionRateCard(),
                const SizedBox(height: 24),
                const CategoryChart(),
                const SizedBox(height: 24),
                const PriorityChart(),
                const SizedBox(height: 24),
                const TimeEstimationCard(),
                const SizedBox(height: 24),
                const ProductivityInsights(),
              ],
            ),
          );
        },
      ),
    );
  }
}
