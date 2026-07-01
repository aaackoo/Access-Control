import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/features/access_keys_admin/widgets/access_key_header.dart';
import 'package:access_control/features/access_keys_admin/widgets/access_keys_list.dart';
import 'package:access_control/features/widgets/general_add_button.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/features/widgets/general_loading_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccessKeysAdminPage extends ConsumerWidget {
  const AccessKeysAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final accessKeysAsync = ref.watch(accessKeysNotifierProvider);

    return Scaffold(
      body: currentUserAsync.when(
        loading: () => const LoadingScreen(),
        error: (error, stack) => GeneralErrorState(error: error),
        data: (currentUser) {
          if (currentUser == null) {
            return Center(child: Text(context.l10n.notLoggedIn));
          }

          return Column(
            children: [
              AccessKeysHeader(accessKeysAsync: accessKeysAsync),
              Expanded(
                child: accessKeysAsync.when(
                  data: (accessKeys) => RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(accessKeysNotifierProvider),
                    child: accessKeys.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: MediaQuery.of(context).size.height,
                              ),
                              child: GeneralEmptyState(
                                icon: Icons.admin_panel_settings_outlined,
                                title: context.l10n.noKeys,
                                subtitle:
                                    context.l10n.addAccountsUsingButtonBelow,
                              ),
                            ),
                          )
                        : AccessKeysList(accessKeys: accessKeys),
                  ),
                  loading: () => const LoadingScreen(),
                  error: (error, stack) => GeneralErrorState(
                    error: error,
                    onRetry: () => ref.invalidate(accessKeysNotifierProvider),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: GeneralAddButton(
        title: context.l10n.addKey,
        icon: Icons.admin_panel_settings,
        onTap: () => context.push(Routes.addAccessKeyPath),
      ),
    );
  }
}
