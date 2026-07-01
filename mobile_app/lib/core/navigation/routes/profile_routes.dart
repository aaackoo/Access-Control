import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/features/user_profile/user_profile_page.dart';
import 'package:go_router/go_router.dart';

GoRoute getProfileRoute() {
  return GoRoute(
    path: Routes.profile,
    name: 'profile',
    builder: (context, state) => const UserProfilePage(),
  );
}
