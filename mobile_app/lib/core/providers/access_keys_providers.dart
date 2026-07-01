import 'package:access_control/core/notifiers/access_keys_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/access_key.dart';
import 'package:access_control/models/account_key_assignment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accessKeysNotifierProvider =
    StateNotifierProvider<AccessKeysNotifier, AsyncValue<List<AccessKey>>>(
        (ref) {
  return AccessKeysNotifier(ref);
});

final accessKeysByIdsProvider =
    FutureProvider.family<List<AccessKey>, List<String>>((ref, roleIds) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccessKeysByIds(roleIds);
});

final accessKeyByIdProvider =
    FutureProvider.family<AccessKey?, String>((ref, id) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccessKeyById(id);
});

final accessKeysByAccountIdProvider =
    FutureProvider.family<List<AccessKey>, String>((ref, accountId) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccessKeysByAccountId(accountId);
});

final accountKeyAssignmentsProvider =
    FutureProvider.family<List<AccountKeyAssignment>, String>(
        (ref, accountId) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAccountKeyAssignments(accountId);
});
