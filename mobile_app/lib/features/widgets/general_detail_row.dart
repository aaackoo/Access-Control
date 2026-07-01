import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';

class GeneralDetailRow extends StatelessWidget {
  const GeneralDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: ACTextStyles.bodyText(
                ACColors.textDim,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: ACTextStyles.bodyText(
                ACColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
