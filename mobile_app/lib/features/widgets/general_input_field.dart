import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInputField extends StatelessWidget {
  const GeneralInputField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    required this.hintText,
    required this.validator,
    this.onSubmit,
    this.onSaved,
    this.minLines = 1,
    this.maxLines = 1,
    this.autoFocus = false,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final IconData icon;
  final String label;
  final String hintText;
  final String? Function(String?) validator;
  final void Function(String?)? onSaved;
  final int minLines;
  final int maxLines;
  final bool autoFocus;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ACTextStyles.bodyText(ACColors.text),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ACColors.primary),
            ),
            prefixIcon: Icon(icon, color: ACColors.primary),
          ),
          validator: validator,
          onSaved: onSaved,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => onSubmit?.call(),
          minLines: minLines,
          maxLines: maxLines,
          autofocus: autoFocus,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
