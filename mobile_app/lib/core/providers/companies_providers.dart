import 'package:access_control/core/notifiers/companies_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/company.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final companiesNotifierProvider =
    StateNotifierProvider<CompaniesNotifier, AsyncValue<List<Company>>>((ref) {
  return CompaniesNotifier(ref);
});

final companyByIdProvider =
    FutureProvider.family<Company?, String>((ref, id) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getCompanyById(id);
});
