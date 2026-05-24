import 'package:flutter/material.dart';
import 'expense_keyboard_key.dart';

class ExpenseNumpad extends StatelessWidget {
  final Function(String value) onKeyTap;

  const ExpenseNumpad({
    super.key,
    required this.onKeyTap,
  });

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          children: row.map((key) {
            return Expanded(
              child: ExpenseKeyboardKey(
                keyText: key,
                onTap: () => onKeyTap(key),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}