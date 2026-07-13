import 'package:flutter/material.dart';

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
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(useCloseIcon ? Icons.close : Icons.arrow_back),
        color: Colors.black,
        onPressed: onLeading ?? () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (onMenu != null)
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: onMenu,
          ),
      ],
    );
  }
}