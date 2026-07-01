import 'package:access_control/features/widgets/general_header.dart';
import 'package:access_control/models/access_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessKeysHeader extends StatelessWidget {
  const AccessKeysHeader({super.key, required this.accessKeysAsync});

  final AsyncValue<List<AccessKey>> accessKeysAsync;

  @override
  Widget build(BuildContext context) {
    return GeneralHeader(
      async: accessKeysAsync,
      icon: Icons.admin_panel_settings_outlined,
      type: HeaderType.accessKey,
    );
  }
}
