import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';

class GeneralAddButton extends StatelessWidget {
  const GeneralAddButton({
    super.key,
    required this.title,
    this.onTap,
    this.icon,
  });

  final String title;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: FloatingActionButton.extended(
        heroTag: null,
        onPressed: onTap,
        backgroundColor:
            isEnabled ? (ACColors.backgroundAccent) : ACColors.backgroundDimmed,
        icon: Icon(
          icon ?? Icons.person_add,
          color: isEnabled ? ACColors.text : ACColors.textDim,
        ),
        label: Text(
          title,
          style: ACTextStyles.appBarTitle(
            isEnabled ? ACColors.text : ACColors.textDim,
          ),
        ),
      ),
    );
  }
}
