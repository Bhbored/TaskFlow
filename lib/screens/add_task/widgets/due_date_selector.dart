import 'package:flutter/material.dart';

class DueDateSelector extends StatelessWidget {
  final DateTime? selectedDueDate;
  final ValueChanged<DateTime?> onDueDateSelected;

  const DueDateSelector({
    super.key,
    required this.selectedDueDate,
    required this.onDueDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDueDate(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(
                  selectedDueDate != null
                      ? '${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year}'
                      : 'Select due date (optional)',
                  style: TextStyle(
                    color: selectedDueDate != null ? null : Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (selectedDueDate != null)
                  IconButton(
                    onPressed: () => onDueDateSelected(null),
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear due date',
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      onDueDateSelected(date);
    }
  }
}
