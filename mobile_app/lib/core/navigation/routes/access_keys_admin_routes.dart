import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/features/access_keys_admin/access_keys_admin_page.dart';
import 'package:access_control/features/access_keys_admin/widgets/access_key_form_page.dart';
import 'package:access_control/features/access_keys_admin/widgets/select_devices_page.dart';
import 'package:access_control/models/access_key.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch getAccessKeysAdminRoute() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.accesses,
        name: 'accesses',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const AccessKeysAdminPage(),
        ),
        routes: [
          GoRoute(
            path: Routes.addAccessKey,
            name: 'add-access-key',
            builder: (context, state) => const AccessKeyFormPage(),
            routes: [
              GoRoute(
                path: Routes.selectDevices,
                name: 'select-devices',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  return SelectDevicesPage(
                    buildingId: extra['buildingId'] as String,
                    initialSelectedIds:
                        extra['initialSelectedIds'] as Set<String>,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '${Routes.editAccessKey}/:roleId',
            name: 'edit-access-key',
            builder: (context, state) {
              final role = state.extra as AccessKey;
              return AccessKeyFormPage(existingAccessKey: role);
            },
            routes: [
              GoRoute(
                path: Routes.selectDevices,
                name: 'edit-access-key-select-devices',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  return SelectDevicesPage(
                    buildingId: extra['buildingId'] as String,
                    initialSelectedIds:
                        extra['initialSelectedIds'] as Set<String>,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
