import 'package:access_control/core/notifiers/crud_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/building.dart';

class BuildingsNotifier extends CrudNotifier<Building> {
  BuildingsNotifier(super.ref);

  @override
  Future<List<Building>> fetchData() =>
      ref.read(supabaseDatabaseProvider).getBuildings();

  Future<void> addBuilding(Building building) =>
      mutate(() => ref.read(supabaseDatabaseProvider).addBuilding(building));

  Future<void> updateBuilding(Building building) =>
      mutate(() => ref.read(supabaseDatabaseProvider).updateBuilding(building));

  Future<void> deleteBuilding(String id) =>
      mutate(() => ref.read(supabaseDatabaseProvider).deleteBuilding(id));
}
