import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';

class SpendsmartAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;
  const SpendsmartAppbar({
    super.key,
    this.profileImageUrl,
    required this.onProfileTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: onMenuTap, icon: Icon(Icons.menu)),
      actionsPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        'SpendSmart',
        style: AppTextStyles.body.copyWith(
          color: AppColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: onProfileTap,
          child: CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(
              'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
