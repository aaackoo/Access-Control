import 'package:access_control/core/notifiers/crud_notifier.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/access_key.dart';

class AccessKeysNotifier extends CrudNotifier<AccessKey> {
  AccessKeysNotifier(super.ref);

  @override
  Future<List<AccessKey>> fetchData() async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null || user.companyId.isEmpty) return [];
    return ref
        .read(supabaseDatabaseProvider)
        .getAccessKeysWithRelations(user.companyId);
  }

  Future<void> addAccessKey(AccessKey accessKey) =>
      mutate(() => ref.read(supabaseDatabaseProvider).addAccessKey(accessKey));

  Future<void> updateAccessKey(AccessKey accessKey) => mutate(
        () => ref.read(supabaseDatabaseProvider).updateAccessKey(accessKey),
      );

  Future<void> deleteAccessKey(String id) =>
      mutate(() => ref.read(supabaseDatabaseProvider).deleteAccessKey(id));
}
