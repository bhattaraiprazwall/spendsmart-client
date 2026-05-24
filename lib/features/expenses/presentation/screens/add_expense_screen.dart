


import 'package:flutter/material.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/features/expenses/models/expense_form_data.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/amount_display.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/expense_form_card.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/expense_numpad.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen> {

  ExpenseFormData formData =
      const ExpenseFormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AmountDisplay(
              amount: formData.amount,
            ),

            const SizedBox(height: 40),

            ExpenseFormCard(
              formData: formData,
            ),

            const SizedBox(height: 40),

            Expanded(
              child: ExpenseNumpad(
                onKeyTap: _handleKeyTap,
              ),
            ),

            PrimaryButton(onPressed: (){}, label: 'Save Expense'),
          ],
        ),
      ),
    );
  }

  void _handleKeyTap(String value) {
    // numpad logic
  }
}