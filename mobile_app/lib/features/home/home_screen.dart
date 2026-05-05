import 'dart:ui';

import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/core/providers/home_screen_providers.dart';
import 'package:access_control/features/home/widgets/tap_to_scan.dart';
import 'package:access_control/features/home/widgets/user_keys_stats_widget.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/features/widgets/general_loading_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: ACColors.background,
      body: currentUserAsync.when(
        loading: () => const LoadingScreen(),
        error: (error, stack) => GeneralErrorState(error: error),
        data: (currentUser) {
          if (currentUser == null) {
            return Center(child: Text(context.l10n.notLoggedIn));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref
                ..invalidate(currentUserKeysProvider)
                ..invalidate(userKeysStatsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: ACColors.background,
                    width: double.infinity,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/icons/logo.png',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Text(
                            '${context.l10n.welcome}, ${currentUser.email}',
                            style: ACTextStyles.headlineTitle(ACColors.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        gradient: ACGradients.accentPrimaryGradient,
                      ),
                      child: const UserKeysStatsWidget(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const TapToScan(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
