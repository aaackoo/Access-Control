import 'package:access_control/core/navigation/home_screen_wrapper.dart';
import 'package:access_control/core/navigation/routes/access_keys_admin_routes.dart';
import 'package:access_control/core/navigation/routes/account_routes.dart';
import 'package:access_control/core/navigation/routes/admin_routes.dart';
import 'package:access_control/core/navigation/routes/home_routes.dart';
import 'package:access_control/core/navigation/routes/user_access_keys_routes.dart';
import 'package:go_router/go_router.dart';

StatefulShellRoute getMainShellRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return HomeScreenWrapper(navigationShell: navigationShell);
    },
    branches: [
      getHomeRoute(),
      getUserAccessKeysRoute(),
      getAccountsRoute(),
      getAccessKeysAdminRoute(),
      getAdminRoute(),
    ],
  );
}
