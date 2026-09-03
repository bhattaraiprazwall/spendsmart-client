import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/widgets/dialogs/exit_confirmation_dialog.dart';
import 'package:spendsmart/core/widgets/navigation/bottom_nav_bar.dart';
import 'package:spendsmart/features/home/presentation/widgets/quick_action_sheet.dart';

class HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        ExitConfirmationDialog.show(context);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTabChanged: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          onFabTap: () => showQuickActionSheet(context),
        ),
      ),
    );
  }
}
