import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbar({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.l10n.myProfileTitle,
        style: ACTextStyles.appBarTitle(
          ACColors.text,
        ),
      ),
      centerTitle: true,
      backgroundColor: ACColors.backgroundDimmed,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout_outlined,
            color: ACColors.text,
          ),
          onPressed: onLogout,
        ),
      ],
      leading: BackButton(
        color: ACColors.text,
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
