import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';

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
    final c = context.colors;
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: c.border.withValues(alpha: isDark ? 0.3 : 0.6),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              // Tab 0: Dashboard
              Expanded(
                child: _NavItem(
                  icon: Icons.grid_view_outlined,
                  activeIcon: Icons.grid_view_rounded,
                  label: context.tr('dashboard'),
                  isSelected: currentIndex == 0,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTabChanged(0);
                  },
                ),
              ),

              // Tab 1: Transactions
              Expanded(
                child: _NavItem(
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long_rounded,
                  label: context.tr('transaction'),
                  isSelected: currentIndex == 1,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTabChanged(1);
                  },
                ),
              ),

              // Center Action Button (+)
              Expanded(
                child: _CenterActionButton(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onFabTap();
                  },
                ),
              ),

              // Tab 2: Insights
              Expanded(
                child: _NavItem(
                  icon: Icons.auto_graph_outlined,
                  activeIcon: Icons.auto_graph_rounded,
                  label: context.tr('insights'),
                  isSelected: currentIndex == 2,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTabChanged(2);
                  },
                ),
              ),

              // Tab 3: Profile
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: context.tr('profile'),
                  isSelected: currentIndex == 3,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTabChanged(3);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return InkResponse(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      containedInkWell: true,
      radius: 36,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 12 : 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 22,
                color: isSelected ? AppColors.primary : c.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : c.textSecondary,
              letterSpacing: isSelected ? -0.1 : 0,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 4 : 0,
            height: isSelected ? 4 : 0,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterActionButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CenterActionButton({required this.onTap});

  @override
  State<_CenterActionButton> createState() => _CenterActionButtonState();
}

class _CenterActionButtonState extends State<_CenterActionButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Transform.translate(
        offset: const Offset(0, -10),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutQuad,
          child: Center(
            child: Container(
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(3.5),
              decoration: BoxDecoration(
                color: c.card,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.38),
                    blurRadius: 14,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4F7DFF),
                      Color(0xFF2548E8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
