import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool useCloseIcon;        // true = ×  |  false = ←
  final VoidCallback? onLeading;  // null = Navigator.pop
  final VoidCallback? onMenu;     // null = no menu icon shown

  const AppTopBar({
    super.key,
    required this.title,
    this.useCloseIcon = false,
    this.onLeading,
    this.onMenu,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppBar(
      backgroundColor: c.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(useCloseIcon ? Icons.close : Icons.arrow_back),
        color: c.textPrimary,
        onPressed: onLeading ?? () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: c.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (onMenu != null)
          IconButton(
            icon: Icon(Icons.more_vert, color: c.textPrimary),
            onPressed: onMenu,
          ),
      ],
    );
  }
}