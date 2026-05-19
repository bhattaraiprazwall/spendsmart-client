import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _amount = '0.00';
  String _selectedCategory = 'Select Category';
  String _selectedDate = 'Today';
  String _selectedMethod = 'Card';
  String _note = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.close, color: Colors.black),
        ),
        title: Text(
          'Add Expense',
          style: AppTextStyles.body.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _amountDisplay(),
            const SizedBox(height: 20),
            _formCard(),
            const SizedBox(height: 50),
            Expanded(child: _numpad()),
            PrimaryButton(onPressed: () {}, label: 'Save Expense ☑️'),
          ],
        ),
      ),
    );
  }

  Widget _amountDisplay() {
    return Column(
      children: [
        const Text('How much?', style: AppTextStyles.body),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
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
              '0.00',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('CATEGORY'),
          const SizedBox(height: 8),
          _categoryRow(),
          const Divider(height: 24),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('DATE'),
                      const SizedBox(height: 6),
                      _iconText(Icons.calendar_today_outlined, 'Today'),
                    ],
                  ),
                ),
                VerticalDivider(color: Colors.grey, thickness: 1, width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('METHOD'),
                      const SizedBox(height: 6),
                      _iconText(Icons.credit_card_outlined, 'Card'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          _fieldLabel('NOTE'),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.edit_note_outlined,
                size: 18,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 6),
              Text(
                _note.isEmpty ? 'What was this for?' : _note,
                style: TextStyle(
                  color: _note.isEmpty ? Colors.grey.shade400 : Colors.black87,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade500,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _categoryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //left side select category section
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.category_outlined,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Select Category',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),

        //Right Side Food Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.fastfood_outlined,
                size: 14,
                color: Colors.blue.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                'Food?',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numpad() {
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
            return Expanded(child: _numpadKey(key));
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _numpadKey(String key) {
    final bool isBackspace = key == '⌫';
    return GestureDetector(
      onTap: () => () {},
      child: Container(
        height: 56,
        alignment: Alignment.center,
        child: isBackspace
            ? const Icon(Icons.backspace_outlined, size: 22)
            : Text(
                key,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
