import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/features/auth/auth_screen.dart';
import 'package:go_router/go_router.dart';

GoRoute getAuthRoute() {
  return GoRoute(
    path: Routes.auth,
    name: 'auth',
    builder: (context, state) => const AuthScreen(),
  );
}
