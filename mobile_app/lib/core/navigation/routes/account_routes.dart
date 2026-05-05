import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/features/accounts/account_detail_page.dart';
import 'package:access_control/features/accounts/accounts_screen.dart';
import 'package:access_control/features/accounts/widgets/add_account_page.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch getAccountsRoute() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: Routes.accounts,
        name: 'accounts',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const AccountsScreen(),
        ),
        routes: [
          GoRoute(
            path: Routes.addAccount,
            name: 'add-account',
            builder: (context, state) {
              final companyId = state.extra as String;
              return AddAccountPage(companyId: companyId);
            },
          ),
          GoRoute(
            path: ':accountId',
            name: 'account-detail',
            builder: (context, state) {
              final accountId = state.pathParameters['accountId']!;
              return AccountDetailPage(accountId: accountId);
            },
          ),
        ],
      ),
    ],
  );
}
