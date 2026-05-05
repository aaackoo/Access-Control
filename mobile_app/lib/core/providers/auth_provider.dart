import 'package:access_control/core/notifiers/auth_notifier.dart';
import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/core/providers/areas_providers.dart';
import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/core/services/supabase_service.dart';
import 'package:access_control/models/account.dart';
import 'package:access_control/models/company.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

final currentUserProvider = FutureProvider<Account?>((ref) async {
  final isAuthenticated = ref.watch(authNotifierProvider).isAuthenticated;

  if (!isAuthenticated) return null;

  final supabaseUser = SupabaseService().currentUser;
  final email = supabaseUser?.email;
  if (email == null) return null;

  // Always fetch fresh data from database
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccountByEmail(email);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isLoading;
});

final currentUserCompanyProvider = FutureProvider<Company?>((ref) async {
  final currentUserAsync = await ref.watch(currentUserProvider.future);
  if (currentUserAsync == null) return null;

  final db = ref.read(supabaseDatabaseProvider);
  return db.getCompanyById(currentUserAsync.companyId);
});

final currentUserStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final currentUserAsync = await ref.watch(currentUserProvider.future);
  if (currentUserAsync == null) return {};

  ref
    ..watch(devicesNotifierProvider)
    ..watch(buildingsNotifierProvider)
    ..watch(areasNotifierProvider)
    ..watch(accessKeysNotifierProvider);

  final db = ref.read(supabaseDatabaseProvider);
  return db.getCompanyStats(currentUserAsync.companyId);
});
