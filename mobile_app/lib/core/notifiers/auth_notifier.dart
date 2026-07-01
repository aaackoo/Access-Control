import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/core/providers/accounts_providers.dart';
import 'package:access_control/core/providers/areas_providers.dart';
import 'package:access_control/core/providers/buildings_providers.dart';
import 'package:access_control/core/providers/companies_providers.dart';
import 'package:access_control/core/providers/devices_providers.dart';
import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/core/services/supabase_service.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.error,
  });

  final AuthStatus status;
  final Account? user;
  final String? error;

  AuthState copyWith({
    AuthStatus? status,
    Account? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => SupabaseService().isLoggedIn;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error && error != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(const AuthState(status: AuthStatus.initial));

  final Ref ref;

  void _refreshAllNotifiers() {
    ref.read(accountsNotifierProvider.notifier).refresh();
    ref.read(areasNotifierProvider.notifier).refresh();
    ref.read(buildingsNotifierProvider.notifier).refresh();
    ref.read(companiesNotifierProvider.notifier).refresh();
    ref.read(devicesNotifierProvider.notifier).refresh();
    ref.read(accessKeysNotifierProvider.notifier).refresh();
  }

  void _invalidateAllProviders() {
    ref.read(supabaseDatabaseProvider).signOut();

    ref.read(accountsNotifierProvider.notifier).clearData();
    ref.read(areasNotifierProvider.notifier).clearData();
    ref.read(buildingsNotifierProvider.notifier).clearData();
    ref.read(companiesNotifierProvider.notifier).clearData();
    ref.read(devicesNotifierProvider.notifier).clearData();
    ref.read(accessKeysNotifierProvider.notifier).clearData();

    ref.read(selectedCompanyProvider.notifier).state = null;
    ref.read(selectedAreaProvider.notifier).state = null;
    ref.read(selectedBuildingProvider.notifier).state = null;

    ref
      ..invalidate(accountsByCompanyIdProvider)
      ..invalidate(accountByIdProvider)
      ..invalidate(accountByEmailProvider)
      ..invalidate(areasByCompanyIdProvider)
      ..invalidate(areaByIdProvider)
      ..invalidate(buildingsByAreaIdProvider)
      ..invalidate(buildingByIdProvider)
      ..invalidate(devicesByIdsProvider)
      ..invalidate(deviceByIdProvider)
      ..invalidate(devicesForBuildingProvider)
      ..invalidate(accessKeysByIdsProvider)
      ..invalidate(accessKeyByIdProvider);
  }

  Future<void> fetchUser(String email) async {
    try {
      final db = ref.read(supabaseDatabaseProvider);

      final account = await db.getAccountByEmail(email);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: account,
      );

      // debugPrint('Používateľ $account sa úspešne prihlásil cez Supabase');
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Chyba pri prihlasovaní: ${e.toString()}',
      );
      // debugPrint('Auth error: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    try {
      final db = ref.read(supabaseDatabaseProvider);

      final authResponse = await db.signIn(email, password);

      if (authResponse.user == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          error: 'Prihlásenie zlyhalo - neplatné údaje',
        );
        return;
      }

      final account = await db.getAccountByEmail(email);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: account,
      );

      _refreshAllNotifiers();

      // debugPrint('Používateľ $account sa úspešne prihlásil cez Supabase');
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Chyba pri prihlasovaní: ${e.toString()}',
      );
      // debugPrint('Auth error: $e');
    }
  }

  void signOut() {
    try {
      _invalidateAllProviders();

      // Clear auth state
      state = const AuthState(status: AuthStatus.unauthenticated);

      // debugPrint('Používateľ sa odhlásil a všetky dáta boli vymazané');
    } catch (e) {
      // debugPrint('Neuspesne odhlasenie: $e');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> updateProfile(Account updatedAccount) async {
    if (state.user?.id != updatedAccount.id) return;

    state = state.copyWith(status: AuthStatus.loading);

    try {
      final db = ref.read(supabaseDatabaseProvider);
      await db.updateAccount(updatedAccount);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedAccount,
      );

      // debugPrint('Profil používateľa bol aktualizovaný');
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: 'Chyba pri aktualizácii profilu: ${e.toString()}',
      );
    }
  }
}
