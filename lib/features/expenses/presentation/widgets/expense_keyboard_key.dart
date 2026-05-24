import 'package:flutter/material.dart';

class ExpenseKeyboardKey extends StatelessWidget {
  final String keyText;
  final VoidCallback onTap;

  const ExpenseKeyboardKey({
    super.key,
    required this.keyText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBackspace =
        keyText == '⌫';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        child: isBackspace
            ? const Icon(
                Icons.backspace_outlined,
                size: 22,
              )
            : Text(
                keyText,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}