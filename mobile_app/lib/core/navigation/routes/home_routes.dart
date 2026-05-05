import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/features/home/home_screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch getHomeRoute() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.home,
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
    ],
  );
}
