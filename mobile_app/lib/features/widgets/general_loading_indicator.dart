import 'package:access_control/core/constants/ac_colors.dart';
import 'package:flutter/material.dart';

class LoadingRow extends StatelessWidget {
  const LoadingRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: ACColors.accent,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
