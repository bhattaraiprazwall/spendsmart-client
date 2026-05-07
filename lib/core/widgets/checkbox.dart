import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';

class TermsCheckBox extends StatefulWidget {
  const TermsCheckBox({super.key});

  @override
  State<TermsCheckBox> createState() => TermsCheckBoxState();
}

class TermsCheckBoxState extends State<TermsCheckBox> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Row(
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (value) {
              setState(() {
                _isChecked = value!;
              });
            },
          ),
          //Text
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'I agree to ', style: AppTextStyles.body),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
