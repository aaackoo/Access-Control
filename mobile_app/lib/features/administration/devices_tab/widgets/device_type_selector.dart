import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';

class DeviceTypeSelector extends StatelessWidget {
  const DeviceTypeSelector({
    super.key,
    required this.selectedDeviceType,
    required this.onChanged,
  });

  final DeviceType selectedDeviceType;
  final ValueChanged<DeviceType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.deviceType,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<DeviceType>(
          initialValue: selectedDeviceType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ACColors.primary),
            ),
            prefixIcon: Icon(
              selectedDeviceType.icon,
              color: ACColors.primary,
            ),
          ),
          items: DeviceType.values.map((type) {
            return DropdownMenuItem<DeviceType>(
              value: type,
              child: Text(type.label),
            );
          }).toList(),
          onChanged: (DeviceType? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}
