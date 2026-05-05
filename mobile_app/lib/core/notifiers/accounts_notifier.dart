import 'package:access_control/core/notifiers/crud_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/account.dart';

class AccountsNotifier extends CrudNotifier<Account> {
  AccountsNotifier(super.ref);

  @override
  Future<List<Account>> fetchData() =>
      ref.read(supabaseDatabaseProvider).getAccounts();

  Future<void> addAccount(Account account) => mutate(
        () => ref.read(supabaseDatabaseProvider).createNewAccount(
              email: account.email,
              companyId: account.companyId,
              role: account.role.roleString,
            ),
      );

  Future<void> updateAccount(Account account) =>
      mutate(() => ref.read(supabaseDatabaseProvider).updateAccount(account));

  Future<void> deleteAccount(String id) =>
      mutate(() => ref.read(supabaseDatabaseProvider).deleteAccount(id));
}
