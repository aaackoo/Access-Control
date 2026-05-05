import 'package:access_control/core/notifiers/areas_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/area.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final areasNotifierProvider =
    StateNotifierProvider<AreasNotifier, AsyncValue<List<Area>>>((ref) {
  return AreasNotifier(ref);
});

final areasByCompanyIdProvider =
    FutureProvider.family<List<Area>, String>((ref, companyId) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAreasByCompanyId(companyId);
});

final areaByIdProvider = FutureProvider.family<Area?, String>((ref, id) async {
  final db = ref.read(supabaseDatabaseProvider);
  return db.getAreaById(id);
});
