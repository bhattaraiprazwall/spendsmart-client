import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onFabTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> navItems = [
      {'icon': Icons.dashboard_rounded, 'label': context.tr('dashboard')},
      {'icon': Icons.receipt_long_outlined, 'label': context.tr('transaction')},
      {'icon': Icons.insights_outlined, 'label': context.tr('insights')},
      {'icon': Icons.person_outline, 'label': context.tr('profile')},
    ];

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.10,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: List.generate(navItems.length, (index) {
                return Expanded(child: _navItem(context, navItems[index], index));
              }),
            ),
          ),
          Positioned(top: -25, child: _fabButton()),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, Map<String, dynamic> item, int index) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              item['icon'] as IconData,
              color: isSelected ? Colors.blue : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item['label'] as String,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.neutral,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fabButton() {
    return GestureDetector(
      onTap: onFabTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 58,
        width: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: AppColors.white, size: 30),
      ),
    );
  }
}
