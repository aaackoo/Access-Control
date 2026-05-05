import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AcAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AcAppbar({super.key, this.currentUser});

  final Account? currentUser;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.l10n.accessControl,
        style: ACTextStyles.appBarTitle(
          ACColors.text,
        ),
      ),
      centerTitle: true,
      backgroundColor: ACColors.backgroundDimmed,
      actions: [
        if (currentUser != null) ...[
          IconButton(
            icon: CircleAvatar(
              radius: 32,
              backgroundColor: ACColors.backgroundAccent,
              child: Text(
                currentUser?.email[0].toUpperCase() ?? '',
                style: ACTextStyles.buttonText(ACColors.text),
              ),
            ),
            onPressed: () {
              context.push(Routes.profile);
            },
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
