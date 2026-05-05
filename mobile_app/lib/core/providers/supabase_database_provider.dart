import 'package:access_control/core/services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supabaseDatabaseProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

final isDatabaseInitializedProvider = FutureProvider<bool>((ref) async {
  final db = ref.read(supabaseDatabaseProvider);
  try {
    final companies = await db.getCompanies();
    return companies.isNotEmpty;
  } catch (e) {
    return false;
  }
});
