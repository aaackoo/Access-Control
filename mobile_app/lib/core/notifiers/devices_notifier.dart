import 'package:access_control/core/notifiers/crud_notifier.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/models/device.dart';

class DevicesNotifier extends CrudNotifier<Device> {
  DevicesNotifier(super.ref);

  @override
  Future<List<Device>> fetchData() =>
      ref.read(supabaseDatabaseProvider).getDevices();

  Future<void> addDevice(Device device) =>
      mutate(() => ref.read(supabaseDatabaseProvider).addDevice(device));

  Future<void> addMultipleDevices({
    required String namePrefix,
    required String buildingId,
    required String companyId,
    required String deviceType,
    required int count,
    int padLength = 3,
  }) =>
      mutate(
        () => ref.read(supabaseDatabaseProvider).createMultipleDevices(
              namePrefix: namePrefix,
              buildingId: buildingId,
              companyId: companyId,
              deviceType: deviceType,
              count: count,
              padLength: padLength,
            ),
      );

  Future<void> updateDevice(Device device) =>
      mutate(() => ref.read(supabaseDatabaseProvider).updateDevice(device));

  Future<void> deleteDevice(String id) =>
      mutate(() => ref.read(supabaseDatabaseProvider).deleteDevice(id));
}
