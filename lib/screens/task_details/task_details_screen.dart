import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import 'widgets/details_header.dart';
import 'widgets/status_section.dart';
import 'widgets/details_section.dart';
import 'widgets/tags_section.dart';
import 'widgets/actions_section.dart';
import '../add_task/add_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(task: task),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Edit task',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsHeader(task: task),
            const SizedBox(height: 24),
            StatusSection(task: task),
            const SizedBox(height: 24),
            DetailsSection(task: task),
            const SizedBox(height: 24),
            TagsSection(task: task),
            const SizedBox(height: 24),
            ActionsSection(task: task),
          ],
        ),
      ),
    );
  }
}
