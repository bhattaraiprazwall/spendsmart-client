import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/common/primary_button.dart';

class Onboarding extends StatelessWidget {
  final String image;
  final String label;
  final String description;
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  const Onboarding({
    super.key,
    required this.image,
    required this.label,
    required this.description,
    this.currentPage = 0,
    this.totalPages = 2,
    required this.onSkip,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(10),
        actions: [
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'Skip',
              style: AppTextStyles.label.copyWith(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      //BODY SECTION
      // Column split into 3 zones:
      //   [1] Expanded — center content (image + text)
      //   [2] Dot indicators
      //   [3] Next button pinned at bottom
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            //ZONE 1 Center Content(Text + Image)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //  CIRCULAR IMAGE
                  Container(
                    height: 220,
                    width: 220,

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(120),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    label,
                    style: AppTextStyles.headline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Description — centered and constrained width
                  SizedBox(
                    width: 240,
                    child: Text(description, textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            //ZONE 2 DOT INDICATORS
            _buildDotIndicators(),
            const SizedBox(height: 24),
            //ZONE 3 NEXT BUTTON
            PrimaryButton(
              onPressed: () {
                onNext();
              },
              label: 'Next',
            ),
            const SizedBox(height: 32), // safe bottom padding
          ],
        ),
      ),
    );
  }

  //DOT INDICATOR BUILDER
  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          totalPages,
          (index) => _buildDot(isActive: index == currentPage),
        ),
      ],
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,

      // ── Active dot is wider, inactive is a small circle ─────
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
