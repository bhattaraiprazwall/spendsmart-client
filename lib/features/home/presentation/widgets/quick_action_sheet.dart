import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/routing/route_paths.dart';

void showQuickActionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _QuickActionSheet(),
  );
}

class _QuickActionSheet extends StatelessWidget {
  const _QuickActionSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(),
            const SizedBox(height: 12),
            _buildItem(
              icon: Icons.arrow_downward_rounded,
              iconBg: Colors.red,
              title: 'Add Expense',
              subtitle: 'With AI category prediction',
              isHighlighted: true,
              onTap: () {
                context.pop(); // Close the bottom sheet
                context.push(RoutePaths.addExpense);},
            ),
            const SizedBox(height: 8),
            _buildItem(
              icon: Icons.arrow_outward_rounded,
              iconBg: Colors.green,
              title: 'Add Income',
              subtitle: 'Stipend, allowance, freelance',
              onTap: () {Navigator.pop(context);
              context.push(RoutePaths.addIncome);},
            ),
            const SizedBox(height: 8),
            _buildItem(
              icon: Icons.add_box_outlined,
              iconBg: Colors.blue,
              title: 'New Category',
              subtitle: 'Create custom spending category',
              onTap: () {Navigator.pop(context);
              context.push(RoutePaths.addCategory);},

            ),
            const SizedBox(height: 8),
            _buildItem(
              icon: Icons.savings_outlined,
              iconBg: Colors.purple,
              title: 'Manage Budget',
              subtitle: 'Set monthly & category limits',
              onTap: () {Navigator.pop(context);
              context.push(RoutePaths.budget);},

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return const Text(
      'QUICK ACTION',
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.white54,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          // first item has a slightly brighter bg to show it's "active"
          color: isHighlighted
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildIconBox(icon, iconBg),
            const SizedBox(width: 14),
            _buildText(title, subtitle),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color bg) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildText(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}