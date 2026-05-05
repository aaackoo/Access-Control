import 'package:access_control/core/navigation/router_provider.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessControl extends ConsumerWidget {
  const AccessControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(isDatabaseInitializedProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Access Control App',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
