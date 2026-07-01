import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';

class GeneralEmptyState extends StatelessWidget {
  const GeneralEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: ACColors.textDim,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: ACTextStyles.headlineTitle(
              ACColors.textDim,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: ACTextStyles.bodyText(
              ACColors.textDim,
            ),
          ),
        ],
      ),
    );
  }
}
