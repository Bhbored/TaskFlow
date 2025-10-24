import 'package:flutter/material.dart';

class EstimatedTimeField extends StatelessWidget {
  final TextEditingController controller;

  const EstimatedTimeField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Estimated Time (minutes)',
        hintText: '30',
        prefixIcon: Icon(Icons.access_time),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter estimated time';
        }
        final minutes = int.tryParse(value);
        if (minutes == null || minutes <= 0) {
          return 'Please enter a valid number of minutes';
        }
        return null;
      },
    );
  }
}
