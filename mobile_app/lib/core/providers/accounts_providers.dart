import 'package:access_control/core/notifiers/accounts_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountsNotifierProvider =
    StateNotifierProvider<AccountsNotifier, AsyncValue<List<Account>>>((ref) {
  return AccountsNotifier(ref);
});

final accountsByCompanyIdProvider =
    FutureProvider.family<List<Account>, String>((ref, companyId) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccountsByCompanyId(companyId);
});

final accountByIdProvider =
    FutureProvider.family<Account?, String>((ref, id) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccountById(id);
});

final accountByEmailProvider =
    FutureProvider.family<Account?, String>((ref, email) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccountByEmail(email);
});
