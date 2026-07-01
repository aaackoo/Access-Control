import 'package:access_control/features/access_keys_admin/widgets/access_key_tile.dart';
import 'package:access_control/models/access_key.dart';
import 'package:flutter/material.dart';

class AccessKeysList extends StatelessWidget {
  const AccessKeysList({super.key, required this.accessKeys});

  final List<AccessKey> accessKeys;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: accessKeys.length,
      itemBuilder: (context, index) {
        return AccessKeyTile(accessKey: accessKeys[index]);
      },
    );
  }
}
