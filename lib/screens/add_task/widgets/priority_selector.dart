import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';

class PrioritySelector extends StatelessWidget {
  final TaskPriority selectedPriority;
  final ValueChanged<TaskPriority> onPrioritySelected;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TaskPriority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            return FilterChip(
              label: Text(priority.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onPrioritySelected(priority);
                }
              },
              selectedColor: AppTheme.getPriorityColor(
                priority,
              ).withOpacity(0.2),
              checkmarkColor: AppTheme.getPriorityColor(priority),
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: AppTheme.getPriorityColor(priority),
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
