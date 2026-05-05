import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/navigation/routes/routes.dart';
import 'package:access_control/core/providers/home_screen_providers.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserKeysStatsWidget extends ConsumerWidget {
  const UserKeysStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userKeysStatsProvider);

    return statsAsync.when(
      data: (stats) {
        return GestureDetector(
          onTap: () => context.go(Routes.userAccessKeys),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.key,
                      color: ACColors.text,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.yourAccessKeys,
                            style: ACTextStyles.bodyText(
                              ACColors.text,
                            ),
                          ),
                          Text(
                            context.l10n.totalAccessKeysCount(
                              stats['totalKeys'] ?? 0,
                            ),
                            style: ACTextStyles.smallerBodyText(
                              ACColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context.l10n.areas,
                        stats['uniqueAreas'].toString(),
                        Icons.location_city,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context.l10n.buildings,
                        stats['uniqueBuildings'].toString(),
                        Icons.apartment,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context.l10n.devices,
                        stats['totalDevices'].toString(),
                        Icons.door_front_door,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.key, color: ACColors.white, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.loadingKeys,
                    style: ACTextStyles.bodyText(
                      ACColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    height: 4,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white30,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.error, color: ACColors.white, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.errorDuringLoadingKeys,
                style: ACTextStyles.bodyText(
                  ACColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white30,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: ACColors.text,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: ACTextStyles.bodyText(
              ACColors.text,
            ),
          ),
          Text(
            label,
            style: ACTextStyles.smallerBodyText(
              ACColors.textDim,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
