import 'package:cached_network_image/cached_network_image.dart';
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
  // ── Single place to validate the URL ──────────────────────────
  bool get _hasValidImage =>
      profileImageUrl != null && profileImageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        color: Colors.black,
        onPressed: onMenuTap,
        icon: Icon(Icons.menu),
      ),
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
            backgroundColor: Colors.grey.shade200,
            // backgroundImage: _hasValidImage ? NetworkImage(profileImageUrl!) : null,
            // child: _hasValidImage ? null : const Icon(Icons.person,size: 16,),
            child: ClipOval(
              child: _hasValidImage
                  ? CachedNetworkImage(
                      imageUrl: profileImageUrl!,
                      height: 36,
                      width: 36,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const Icon(Icons.person, size: 18);
                      },
                    )
                  : const Icon(Icons.person, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

 
}
