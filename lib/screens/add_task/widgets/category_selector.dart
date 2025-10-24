import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../../models/app_theme.dart';

class CategorySelector extends StatelessWidget {
  final TaskCategory selectedCategory;
  final ValueChanged<TaskCategory> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: TaskCategory.values.map((category) {
            final isSelected = selectedCategory == category;
            return FilterChip(
              label: Text(category.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category);
                }
              },
              selectedColor: AppTheme.getCategoryColor(
                category,
              ).withOpacity(0.2),
              checkmarkColor: AppTheme.getCategoryColor(category),
              backgroundColor: Colors.transparent,
              side: BorderSide(
                color: AppTheme.getCategoryColor(category),
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
