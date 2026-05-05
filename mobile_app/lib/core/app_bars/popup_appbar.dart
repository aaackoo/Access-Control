import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopupAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PopupAppbar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: ACTextStyles.appBarTitle(
          ACColors.text,
        ),
      ),
      centerTitle: true,
      backgroundColor: ACColors.backgroundDimmed,
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
