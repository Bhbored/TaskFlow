import 'package:flutter/material.dart';

class TagsField extends StatelessWidget {
  final TextEditingController controller;

  const TagsField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Tags',
        hintText: 'work, urgent, project (comma separated)',
        prefixIcon: Icon(Icons.tag),
      ),
      textCapitalization: TextCapitalization.none,
    );
  }
}
