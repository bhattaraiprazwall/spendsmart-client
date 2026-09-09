import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';

class FieldLabel extends StatelessWidget {
  final String label;

  const FieldLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: context.colors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}