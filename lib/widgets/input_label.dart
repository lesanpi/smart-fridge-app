import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      label,
      style: textTheme.bodyLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
