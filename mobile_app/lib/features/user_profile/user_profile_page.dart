import 'package:access_control/core/app_bars/profile_appbar.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/features/user_profile/widgets/company_info_card.dart';
import 'package:access_control/features/user_profile/widgets/company_stats_card.dart';
import 'package:access_control/features/user_profile/widgets/sign_out_dialog.dart';
import 'package:access_control/features/user_profile/widgets/user_info_card.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/features/widgets/general_loading_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: currentUserAsync.maybeWhen(
          data: (_) =>
              ProfileAppbar(onLogout: () => _showSignOutDialog(context, ref)),
          orElse: AppBar.new,
        ),
      ),
      body: currentUserAsync.when(
        loading: () => const LoadingScreen(),
        error: (error, stack) => GeneralErrorState(error: error),
        data: (currentUser) {
          if (currentUser == null) {
            return Center(child: Text(context.l10n.notLoggedIn));
          }

          final companyAsync = ref.watch(currentUserCompanyProvider);
          final statsAsync = ref.watch(currentUserStatsProvider);

          return RefreshIndicator(
            onRefresh: () async {
              ref
                ..invalidate(currentUserCompanyProvider)
                ..invalidate(currentUserStatsProvider);
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoCard(user: currentUser),
                  const SizedBox(height: 16),
                  CompanyInfoCard(companyAsync: companyAsync),
                  const SizedBox(height: 16),
                  CompanyStatsCard(statsAsync: statsAsync),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SignOutDialog(
        onConfirm: () {
          ref.read(authNotifierProvider.notifier).signOut();
          context
            ..pop()
            ..go(Routes.auth);
        },
      ),
    );
  }
}
