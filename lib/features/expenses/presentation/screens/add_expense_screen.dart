import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( onPressed: (){},icon: Icon(Icons.close,color: Colors.black,)),
        title: Text(
          'Add Expense',
          style: AppTextStyles.body.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(

        children: [
          _amountDisplay(),
        ],
      ),
    );
  }

  Widget _amountDisplay(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: .center,
      children: [
        const Text('How much?')
      ],

    );
  }
}
