import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';

class SmartForecastCard extends StatelessWidget {
  final String title;
  final String description;

  const SmartForecastCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return 
    Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(20),
          ),
        
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildForecastIcon(),
        
              const SizedBox(width: 14),
        
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
        
                    const SizedBox(height: 10),
        
                    Text(
                      description,
                      style: AppTextStyles.body.copyWith(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () => context.push('/forecast'),
            child: const Text('Spending Forecast'),
          ),
      ],
    );
  }

  Widget _buildForecastIcon() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),

      child: const Icon(Icons.lightbulb, color: Colors.white),
    );
  }
}
