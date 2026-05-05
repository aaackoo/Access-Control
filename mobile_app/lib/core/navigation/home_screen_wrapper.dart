import 'package:access_control/core/app_bars/ac_appbar.dart';
import 'package:access_control/core/navigation/bottom_navigation_bar.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreenWrapper extends ConsumerWidget {
  const HomeScreenWrapper({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.valueOrNull;
    final role = currentUser?.role ?? AccountRole.user;

    return Scaffold(
      appBar: AcAppbar(currentUser: currentUser),
      body: navigationShell,
      bottomNavigationBar: ACBottomNavigationBar(
        navigationShell: navigationShell,
        role: role,
      ),
    );
  }
}
