import 'package:flutter/material.dart';

class AmountDisplay extends StatelessWidget {
  final String amount;

  const AmountDisplay({
    super.key,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'How much?',
          style: TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Text(
              '\$',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(width: 4),

            Text(
              amount,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}