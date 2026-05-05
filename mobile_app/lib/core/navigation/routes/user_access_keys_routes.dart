import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/features/user_access_keys/user_access_keys_screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch getUserAccessKeysRoute() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.userAccessKeys,
        name: 'access-keys',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const UserAccessKeysScreen(),
        ),
      ),
    ],
  );
}
