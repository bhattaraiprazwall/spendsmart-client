import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';

class AlreadyLoginRegister extends StatefulWidget {
  final String text1;
  final String text2;
  const AlreadyLoginRegister({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  State<AlreadyLoginRegister> createState() => _AlreadyLoginRegisterState();
}

class _AlreadyLoginRegisterState extends State<AlreadyLoginRegister> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.text1,
              // style: TextStyle(color: Colors.black, fontSize: 17),
              style: AppTextStyles.body.copyWith(color: Colors.black),
            ),
            TextSpan(
              text: widget.text2,
              // style: TextStyle(
              //   color: AppColors.primary,
              //   fontWeight: FontWeight.bold,
              //   fontSize: 17,
              // ),
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
