import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';
import '../../../providers/task_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  TaskCategory? _selectedCategory;
  TaskStatus? _selectedStatus;
  TaskPriority? _selectedPriority;
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    final taskProvider = context.read<TaskProvider>();
    _selectedCategory = taskProvider.selectedCategory;
    _selectedStatus = taskProvider.selectedStatus;
    _selectedPriority = taskProvider.selectedPriority;
    _showCompleted = taskProvider.showCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filter Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  context.read<TaskProvider>().clearFilters();
                  Navigator.pop(context);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCategoryFilter(),
          const SizedBox(height: 20),
          _buildStatusFilter(),
          const SizedBox(height: 20),
          _buildPriorityFilter(),
          const SizedBox(height: 20),
          _buildCompletedFilter(),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedCategory == null,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = null;
                });
              },
            ),
            ...TaskCategory.values.map((category) {
              return FilterChip(
                label: Text(category.name.toUpperCase()),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
                selectedColor: AppTheme.getCategoryColor(
                  category,
                ).withOpacity(0.2),
                checkmarkColor: AppTheme.getCategoryColor(category),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedStatus == null,
              onSelected: (selected) {
                setState(() {
                  _selectedStatus = null;
                });
              },
            ),
            ...TaskStatus.values.map((status) {
              return FilterChip(
                label: Text(status.name.toUpperCase()),
                selected: _selectedStatus == status,
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? status : null;
                  });
                },
                selectedColor: AppTheme.getStatusColor(status).withOpacity(0.2),
                checkmarkColor: AppTheme.getStatusColor(status),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildPriorityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: _selectedPriority == null,
              onSelected: (selected) {
                setState(() {
                  _selectedPriority = null;
                });
              },
            ),
            ...TaskPriority.values.map((priority) {
              return FilterChip(
                label: Text(priority.name.toUpperCase()),
                selected: _selectedPriority == priority,
                onSelected: (selected) {
                  setState(() {
                    _selectedPriority = selected ? priority : null;
                  });
                },
                selectedColor: AppTheme.getPriorityColor(
                  priority,
                ).withOpacity(0.2),
                checkmarkColor: AppTheme.getPriorityColor(priority),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletedFilter() {
    return Row(
      children: [
        Text(
          'Show Completed Tasks',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Spacer(),
        Switch(
          value: _showCompleted,
          onChanged: (value) {
            setState(() {
              _showCompleted = value;
            });
          },
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }

  void _applyFilters() {
    final taskProvider = context.read<TaskProvider>();
    taskProvider.setSelectedCategory(_selectedCategory);
    taskProvider.setSelectedStatus(_selectedStatus);
    taskProvider.setSelectedPriority(_selectedPriority);
    taskProvider.setShowCompleted(_showCompleted);
    Navigator.pop(context);
  }
}
