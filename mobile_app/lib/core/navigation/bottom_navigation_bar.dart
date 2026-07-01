import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ACBottomNavigationBar extends StatelessWidget {
  const ACBottomNavigationBar({
    super.key,
    required this.navigationShell,
    required this.role,
  });

  final StatefulNavigationShell navigationShell;
  final AccountRole role;

  @override
  Widget build(BuildContext context) {
    final items = _navItems(context);
    return Container(
      color: ACColors.backgroundDimmed,
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (index) {
            final isSelected = navigationShell.currentIndex == index;
            final item = items[index];
            return Expanded(
              child: InkWell(
                onTap: () => _onTap(context, index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.key,
                        color: isSelected ? ACColors.accent : ACColors.primary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.value,
                        style: ACTextStyles.smallerBodyText(
                          isSelected ? ACColors.accent : ACColors.primary,
                        ).copyWith(height: 1),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<MapEntry<IconData, String>> _navItems(BuildContext context) => [
        MapEntry(Icons.home_outlined, context.l10n.home),
        MapEntry(Icons.credit_card_outlined, context.l10n.cards),
        if (role != AccountRole.user)
          MapEntry(Icons.lock_open_outlined, context.l10n.accountsManagement),
        if (role != AccountRole.user)
          MapEntry(Icons.lock_open_outlined, context.l10n.accessesManagement),
        if (role != AccountRole.user)
          MapEntry(
            Icons.admin_panel_settings_outlined,
            context.l10n.companyManagement,
          ),
      ];

  void _onTap(BuildContext context, int index) {
    if (role == AccountRole.user && index >= 2) {
      return;
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
