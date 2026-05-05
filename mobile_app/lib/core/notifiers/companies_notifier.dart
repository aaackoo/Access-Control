import 'package:access_control/core/notifiers/crud_notifier.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/company.dart';

class CompaniesNotifier extends CrudNotifier<Company> {
  CompaniesNotifier(super.ref);

  @override
  Future<List<Company>> fetchData() async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return [];
    final company =
        await ref.read(supabaseDatabaseProvider).getCompanyById(user.companyId);
    return company != null ? [company] : [];
  }

  Future<void> updateCompany(Company company) =>
      mutate(() => ref.read(supabaseDatabaseProvider).updateCompany(company));
}
