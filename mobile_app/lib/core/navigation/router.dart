import 'package:access_control/core/guards/redirect_guard.dart';
import 'package:access_control/core/navigation/routes/auth_routes.dart';
import 'package:access_control/core/navigation/routes/main_shell_routes.dart';
import 'package:access_control/core/navigation/routes/profile_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

GoRouter getRouter({
  required bool isAuthenticated,
  required dynamic currentUser,
  required Listenable refreshListenable,
}) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refreshListenable,
    redirect: (context, state) => redirectGuard(
      isAuthenticated: isAuthenticated,
      currentUser: currentUser,
      state: state,
    ),
    routes: [
      getAuthRoute(),
      getMainShellRoute(),
      getProfileRoute(),
    ],
  );
}
