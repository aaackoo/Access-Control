import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/features/administration/admin_page.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch getAdminRoute() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.administration,
        name: 'company',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const AdminPage(),
        ),
      ),
    ],
  );
}
