import 'package:access_control/core/notifiers/crud_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/area.dart';

class AreasNotifier extends CrudNotifier<Area> {
  AreasNotifier(super.ref);

  @override
  Future<List<Area>> fetchData() =>
      ref.read(supabaseDatabaseProvider).getAreas();

  Future<void> addArea(Area area) =>
      mutate(() => ref.read(supabaseDatabaseProvider).addArea(area));

  Future<void> updateArea(Area area) =>
      mutate(() => ref.read(supabaseDatabaseProvider).updateArea(area));

  Future<void> deleteArea(String id) =>
      mutate(() => ref.read(supabaseDatabaseProvider).deleteArea(id));
}
