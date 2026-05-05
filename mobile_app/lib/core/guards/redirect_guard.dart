import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/models/account.dart';
import 'package:go_router/go_router.dart';

String? redirectGuard({
  required bool isAuthenticated,
  required Account? currentUser,
  required GoRouterState state,
}) {
  final isAuthRoute = state.matchedLocation == Routes.auth;

  if (!isAuthenticated && !isAuthRoute) {
    return Routes.auth;
  }

  if (isAuthenticated && isAuthRoute) {
    return Routes.home;
  }

  // Check role-based access
  final isAdminRoute = state.matchedLocation.startsWith(Routes.accesses) ||
      state.matchedLocation.startsWith(Routes.administration) ||
      state.matchedLocation.startsWith(Routes.accounts);

  if (isAdminRoute && currentUser?.role == AccountRole.user) {
    return Routes.home;
  }

  return null;
}
