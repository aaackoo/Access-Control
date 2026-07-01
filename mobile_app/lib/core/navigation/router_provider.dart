import 'package:access_control/core/navigation/router.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  final currentUserAsync = ref.watch(currentUserProvider);
  final currentUser = currentUserAsync.valueOrNull;

  return getRouter(
    isAuthenticated: isAuthenticated,
    currentUser: currentUser,
    refreshListenable: GoRouterRefreshStream(ref),
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(this.ref) {
    ref
      ..listen<bool>(
        isAuthenticatedProvider,
        (previous, next) => notifyListeners(),
      )
      ..listen<dynamic>(
        currentUserProvider,
        (previous, next) => notifyListeners(),
      );
  }

  final Ref ref;
}
