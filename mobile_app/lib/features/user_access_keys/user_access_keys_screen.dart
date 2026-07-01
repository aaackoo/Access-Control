import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/core/providers/home_screen_providers.dart';
import 'package:access_control/features/user_access_keys/widgets/access_key_card.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/features/widgets/general_loading_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAccessKeysScreen extends ConsumerWidget {
  const UserAccessKeysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: currentUserAsync.when(
        loading: () => const LoadingScreen(),
        error: (error, stack) => GeneralErrorState(error: error),
        data: (currentUser) {
          if (currentUser == null) {
            return Center(
              child: Text(
                context.l10n.notLoggedIn,
                style: ACTextStyles.bodyText(ACColors.text),
              ),
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: ACColors.backgroundDimmed,
                child: TextField(
                  style: ACTextStyles.bodyText(ACColors.text),
                  onChanged: (value) {
                    ref.read(keySearchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: context.l10n.accessSearchPlaceholder,
                    hintStyle: ACTextStyles.bodyText(ACColors.textDim),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: ACColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final keysAsync = ref.watch(filteredUserKeysProvider);

                    return keysAsync.when(
                      data: (keysWithDetails) => RefreshIndicator(
                        onRefresh: () async =>
                            ref.invalidate(currentUserKeysProvider),
                        child: keysWithDetails.isEmpty
                            ? CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  SliverFillRemaining(
                                    child: GeneralEmptyState(
                                      icon: Icons.key_off,
                                      title: context.l10n.noKeys,
                                      subtitle: context.l10n.noKeysDescription,
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: keysWithDetails.length,
                                itemBuilder: (context, index) {
                                  return AccessKeyCard(
                                    keyDetail: keysWithDetails[index],
                                  );
                                },
                              ),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => GeneralErrorState(
                        error: error,
                        customTitle: context.l10n.errorDuringLoadingKeys,
                        onRetry: () => ref.invalidate(currentUserKeysProvider),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
