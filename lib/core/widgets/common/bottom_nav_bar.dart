import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  final Function(int) onTabChanged; // 👈 callback to parent
  const BottomNavBar({super.key, required this.onTabChanged});

  @override
  State<BottomNavBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'DASHBOARD'},
    {'icon': Icons.receipt_long_outlined, 'label': 'TRANSACTION'},
    {'icon': null, 'label': ''}, // 👈 middle FAB placeholder
    {'icon': Icons.insights_outlined, 'label': 'INSIGHTS'},
    {'icon': Icons.person_outline, 'label': 'PROFILE'},
  ];

  void _onTap(int index) {
    if (index == 2) return;
    setState(() {
      _selectedIndex = index;
      widget.onTabChanged(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        //Bottom Bar
        Container(
          height: 70,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              if (index == 2) {
                return const SizedBox(width: 60);
              }
              return _navItem(index);
            }),
          ),
        ),
        // Floating + button
        Positioned(top: -25, child: _fabButton()),
      ],
    );
  }

  Widget _navItem(int index) {
    final item = _navItems[index];
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        _onTap(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    return Container(
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
    );
  }
}
