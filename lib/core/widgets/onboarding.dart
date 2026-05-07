import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/primary_button.dart';

class Onboarding extends StatelessWidget {
  final String image;
  final String label;
  final String description;
  const Onboarding({
    super.key,
    required this.image,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(10),
        actions: [
          Text(
            'Skip',
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        backgroundColor: AppColors.background,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 220,
                width: 220,

                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(image)),
                  borderRadius: BorderRadius.circular(120),
                ),
              ),
              const SizedBox(height: 40),
              Text(label, style: AppTextStyles.headline),
              const SizedBox(height: 10),
              Text(description),

              PrimaryButton(onPressed: () {}, label: 'Next'),
            ],
          ),
        ),
      ),
    );
  }
}
