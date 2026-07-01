import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/core/providers/accounts_providers.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/features/accounts/widgets/account_tile.dart';
import 'package:access_control/features/widgets/general_add_button.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/features/widgets/general_loading_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: currentUserAsync.when(
        loading: () => const LoadingScreen(),
        error: (error, stack) => GeneralErrorState(error: error),
        data: (currentUser) {
          if (currentUser == null) {
            return Center(child: Text(context.l10n.notLoggedIn));
          }

          final accountsAsync = ref.watch(
            accountsByCompanyIdProvider(currentUser.companyId),
          );

          return Column(
            children: [
              _AccountsHeader(accountsAsync: accountsAsync),
              Expanded(
                child: accountsAsync.when(
                  data: (accounts) {
                    if (accounts.isEmpty) {
                      return GeneralEmptyState(
                        icon: Icons.people_outline,
                        title: context.l10n.noAccounts,
                        subtitle: context.l10n.addAccountsUsingButtonBelow,
                      );
                    }
                    return _AccountsList(
                      accounts: accounts,
                      companyId: currentUser.companyId,
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => GeneralErrorState(
                    error: error,
                    customTitle: context.l10n.errorLoadingData,
                    onRetry: () {
                      ref.invalidate(
                        accountsByCompanyIdProvider(currentUser.companyId),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: GeneralAddButton(
        title: context.l10n.addAccount,
        onTap: () {
          final currentUser = ref.read(currentUserProvider).valueOrNull;
          if (currentUser != null) {
            context.push(Routes.addAccountPath(), extra: currentUser.companyId);
          }
        },
      ),
    );
  }
}

class _AccountsHeader extends StatelessWidget {
  const _AccountsHeader({required this.accountsAsync});

  final AsyncValue<List<Account>> accountsAsync;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: ACColors.backgroundDimmed,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.people,
            color: ACColors.accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: accountsAsync.when(
              data: (accounts) => Text(
                context.l10n.totalAccountsCount(accounts.length),
                style: ACTextStyles.appBarTitle(
                  ACColors.text,
                ),
              ),
              loading: () => Text(
                context.l10n.loading,
                style: ACTextStyles.appBarTitle(
                  ACColors.text,
                ),
              ),
              error: (_, __) => Text(
                context.l10n.errorLoadingData,
                style: ACTextStyles.appBarTitle(
                  ACColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountsList extends ConsumerWidget {
  const _AccountsList({
    required this.accounts,
    required this.companyId,
  });

  final List<Account> accounts;
  final String companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(accountsByCompanyIdProvider(companyId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          return AccountTile(account: accounts[index]);
        },
      ),
    );
  }
}
