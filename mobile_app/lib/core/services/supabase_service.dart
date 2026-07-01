import 'package:access_control/models/access_key.dart';
import 'package:access_control/models/account.dart';
import 'package:access_control/models/account_key_assignment.dart';
import 'package:access_control/models/area.dart';
import 'package:access_control/models/building.dart';
import 'package:access_control/models/company.dart';
import 'package:access_control/models/device.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static final SupabaseService _instance = SupabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;
  // MARK: - COMPANIES

  Future<List<Company>> getCompanies() async {
    final response = await _client.from('companies').select();

    return response
        .map((json) => Company.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<Company?> getCompanyById(String id) async {
    final response =
        await _client.from('companies').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return Company.fromJson(_convertFromSnakeCase(response));
  }

  Future<void> updateCompany(Company company) async {
    await _client
        .from('companies')
        .update(_convertToSnakeCase(company.toJson()))
        .eq('id', company.id);
  }

  // MARK: - AREAS

  Future<List<Area>> getAreas() async {
    final response =
        await _client.from('areas').select().eq('is_deleted', false);

    return response
        .map((json) => Area.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<Area?> getAreaById(String id) async {
    final response =
        await _client.from('areas').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return Area.fromJson(_convertFromSnakeCase(response));
  }

  Future<List<Area>> getAreasByCompanyId(String companyId) async {
    final response = await _client
        .from('areas')
        .select()
        .eq('company_id', companyId)
        .eq('is_deleted', false);

    return response
        .map((json) => Area.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<void> addArea(Area area) async {
    final areaData = _convertToSnakeCase(area.toJson())..remove('id');

    await _client.from('areas').insert(areaData);
  }

  Future<void> updateArea(Area area) async {
    await _client
        .from('areas')
        .update(_convertToSnakeCase(area.toJson()))
        .eq('id', area.id);
  }

  Future<void> deleteArea(String id) async {
    await _client.from('areas').update({
      'is_deleted': true,
      'deleted_utc': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  // MARK: - BUILDINGS

  Future<List<Building>> getBuildings() async {
    final response =
        await _client.from('buildings').select().eq('is_deleted', false);
    return _hydrateBuildingsWithAccessKeys(response);
  }

  Future<Building?> getBuildingById(String id) async {
    final response =
        await _client.from('buildings').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return _convertBuildingFromSupabase(response);
  }

  Future<List<Building>> getBuildingsByCompanyId(String companyId) async {
    final response = await _client
        .from('buildings')
        .select()
        .eq('company_id', companyId)
        .eq('is_deleted', false);

    return response
        .map((json) => Building.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<List<Building>> getBuildingsByAreaId(String areaId) async {
    final response = await _client
        .from('buildings')
        .select()
        .eq('area_id', areaId)
        .eq('is_deleted', false);
    return _hydrateBuildingsWithAccessKeys(response);
  }

  Future<void> addBuilding(Building building) async {
    final buildingData = _convertToSnakeCase(building.toJson())
      ..remove('access_key_ids')
      ..remove('id');

    await _client.from('buildings').insert(buildingData);

    // Then update access keys to reference this building
    for (final accessKeyId in building.accessKeyIds) {
      await _client
          .from('access_keys')
          .update({'building_id': building.id}).eq('id', accessKeyId);
    }
  }

  Future<void> updateBuilding(Building building) async {
    final buildingData = _convertToSnakeCase(building.toJson())
      ..remove('access_key_ids'); // Remove this as it's not a column

    await _client.from('buildings').update(buildingData).eq('id', building.id);

    // Update access keys to reference this building
    for (final accessKeyId in building.accessKeyIds) {
      await _client
          .from('access_keys')
          .update({'building_id': building.id}).eq('id', accessKeyId);
    }
  }

  Future<void> deleteBuilding(String id) async {
    await _client.from('buildings').update({
      'is_deleted': true,
      'deleted_utc': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  // MARK: - ACCESS KEYS

  Future<List<AccessKey>> getAccessKeys() async {
    final response =
        await _client.from('access_keys').select().eq('is_deleted', false);
    return _hydrateAccessKeysWithRelations(response);
  }

  Future<AccessKey?> getAccessKeyById(String id) async {
    final response =
        await _client.from('access_keys').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return _convertAccessKeyFromSupabase(response);
  }

  Future<List<AccessKey>> getAccessKeysByCompanyId(String companyId) async {
    final response = await _client
        .from('access_keys')
        .select()
        .eq('company_id', companyId)
        .eq('is_deleted', false);
    return _hydrateAccessKeysWithRelations(response);
  }

  Future<List<AccessKey>> getAccessKeysByIds(List<String> accessKeyIds) async {
    if (accessKeyIds.isEmpty) return [];
    final response = await _client
        .from('access_keys')
        .select()
        .inFilter('id', accessKeyIds)
        .eq('is_deleted', false);
    return _hydrateAccessKeysWithRelations(response);
  }

  Future<List<AccessKey>> getAccessKeysByAccountId(String accountId) async {
    if (accountId.isEmpty) return [];
    final response = await _client
        .from('account_access_key')
        .select()
        .eq('account_id', accountId);
    final accessKeyIds = response
        .map((json) => _convertFromSnakeCase(json)['accessKeyId'] as String)
        .toList();
    if (accessKeyIds.isEmpty) return [];
    final accessKeyResponse = await _client
        .from('access_keys')
        .select()
        .inFilter('id', accessKeyIds)
        .eq('is_deleted', false);
    return _hydrateAccessKeysWithRelations(accessKeyResponse);
  }

  Future<List<AccountKeyAssignment>> getAccountKeyAssignments(
    String accountId,
  ) async {
    if (accountId.isEmpty) return [];
    final response = await _client
        .from('account_access_key')
        .select()
        .eq('account_id', accountId);
    if (response.isEmpty) return [];

    final rows = response.map(_convertFromSnakeCase).toList();
    final accessKeyIds = rows.map((r) => r['accessKeyId'] as String).toList();

    final accessKeyResponse = await _client
        .from('access_keys')
        .select()
        .inFilter('id', accessKeyIds)
        .eq('is_deleted', false);
    final accessKeys = await _hydrateAccessKeysWithRelations(accessKeyResponse);
    final accessKeyMap = {for (final k in accessKeys) k.id: k};

    return rows
        .map((row) {
          final accessKey = accessKeyMap[row['accessKeyId'] as String];
          if (accessKey == null) return null;
          return AccountKeyAssignment(
            accessKey: accessKey,
            grantedBy: row['grantedBy'] as String?,
            validFromUtc: row['validFromUtc'] != null
                ? DateTime.parse(row['validFromUtc'] as String)
                : null,
            validToUtc: row['validToUtc'] != null
                ? DateTime.parse(row['validToUtc'] as String)
                : null,
          );
        })
        .whereType<AccountKeyAssignment>()
        .toList();
  }

  Future<void> addAccessKey(AccessKey accessKey) async {
    // First insert the access key
    final accessKeyData = _convertToSnakeCase(accessKey.toJson())
      ..remove('id')
      ..remove('device_ids');

    final insertedAccessKey = await _client
        .from('access_keys')
        .insert(accessKeyData)
        .select('id')
        .single();

    final newAccessKeyId = insertedAccessKey['id'] as String;

    // Then add device relationships
    for (final deviceId in accessKey.deviceIds) {
      await _client.from('device_access_key').insert({
        'device_id': deviceId,
        'access_key_id': newAccessKeyId,
      });
    }
  }

  Future<void> updateAccessKey(AccessKey accessKey) async {
    final accessKeyData = _convertToSnakeCase(accessKey.toJson())
      ..remove('device_ids');

    await _client
        .from('access_keys')
        .update(accessKeyData)
        .eq('id', accessKey.id);

    // Remove existing relationships
    await _client
        .from('device_access_key')
        .delete()
        .eq('access_key_id', accessKey.id);

    // Add new device relationships
    for (final deviceId in accessKey.deviceIds) {
      await _client.from('device_access_key').insert({
        'device_id': deviceId,
        'access_key_id': accessKey.id,
      });
    }
  }

  Future<void> deleteAccessKey(String id) async {
    await _client.from('access_keys').update({
      'is_deleted': true,
      'deleted_utc': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  Future<void> assignAccessKeyToAccount(
    String accountId,
    String accessKeyId, {
    required String grantedBy,
    DateTime? validFromUtc,
    DateTime? validToUtc,
  }) async {
    await _client.from('account_access_key').insert({
      'account_id': accountId,
      'access_key_id': accessKeyId,
      'granted_by': grantedBy,
      if (validFromUtc != null)
        'valid_from_utc': validFromUtc.toUtc().toIso8601String(),
      if (validToUtc != null)
        'valid_to_utc': validToUtc.toUtc().toIso8601String(),
    });
  }

  Future<void> updateAccessKeyAssignment(
    String accountId,
    String accessKeyId, {
    DateTime? validFromUtc,
    DateTime? validToUtc,
  }) async {
    await _client
        .from('account_access_key')
        .update({
          'valid_from_utc': validFromUtc?.toUtc().toIso8601String(),
          'valid_to_utc': validToUtc?.toUtc().toIso8601String(),
        })
        .eq('account_id', accountId)
        .eq('access_key_id', accessKeyId);
  }

  Future<void> removeAccessKeyFromAccount(
    String accountId,
    String accessKeyId,
  ) async {
    await _client
        .from('account_access_key')
        .delete()
        .eq('account_id', accountId)
        .eq('access_key_id', accessKeyId);
  }

  // MARK: - DEVICES

  Future<List<Device>> getDevices() async {
    final response =
        await _client.from('devices').select().eq('is_deleted', false);

    return response
        .map((json) => Device.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<Device?> getDeviceById(String id) async {
    final response =
        await _client.from('devices').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return Device.fromJson(_convertFromSnakeCase(response));
  }

  Future<List<Device>> getDevicesByCompanyId(String companyId) async {
    final response = await _client
        .from('devices')
        .select()
        .eq('company_id', companyId)
        .eq('is_deleted', false);

    return response
        .map((json) => Device.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<List<Device>> getDevicesByBuildingId(String buildingId) async {
    final response = await _client
        .from('devices')
        .select()
        .eq('building_id', buildingId)
        .eq('is_deleted', false);

    return response
        .map((json) => Device.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<List<Device>> getDevicesByAccessKeyIds(
    List<String> accessKeyIds,
  ) async {
    if (accessKeyIds.isEmpty) return [];

    final response = await _client
        .from('device_access_key')
        .select()
        .inFilter('access_key_id', accessKeyIds);

    final devicesIds = <String>[];
    for (final json in response) {
      final x = _convertFromSnakeCase(json);
      devicesIds.add(x['device_id'] as String);
    }

    final devices = <Device>[];

    final deviceResponse = await _client
        .from('devices')
        .select()
        .inFilter('id', devicesIds)
        .eq('is_deleted', false);
    for (final json in deviceResponse) {
      final device = _convertFromSnakeCase(json);
      devices.add(Device.fromJson(device));
    }

    return devices;
  }

  Future<List<Device>> getDevicesByIds(List<String> deviceIds) async {
    if (deviceIds.isEmpty) return [];

    final response = await _client
        .from('devices')
        .select()
        .inFilter('id', deviceIds)
        .eq('is_deleted', false);

    return response
        .map((json) => Device.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<void> addDevice(Device device) async {
    final response = await _client.functions.invoke(
      'create-iot-device',
      body: {
        'name': device.name,
        'type': Device.getStringFromDeviceType(device.deviceType),
        'company_id': device.companyId,
        'building_id': device.buildingId,
      },
    );

    if (response.status != 200) {
      final error = response.data?['error'] ?? 'Unknown error';
      throw Exception('Failed to create device: $error');
    }
  }

  Future<void> createMultipleDevices({
    required String namePrefix,
    required String buildingId,
    required String companyId,
    required String deviceType,
    int count = 1,
    int padLength = 3,
  }) async {
    final response = await _client.functions.invoke(
      'bulk-create-iot-devices',
      body: {
        'name_prefix': namePrefix,
        'pad_length': padLength,
        'count': count,
        'type': deviceType,
        'company_id': companyId,
        'building_id': buildingId,
      },
    );

    if (response.status == 207) {
      final data = response.data as Map<String, dynamic>;
      throw Exception(
        'Partial failure: ${data['successful_count']} created, ${data['failed_count']} failed',
      );
    }

    if (response.status != 200) {
      final error = response.data?['error'] ?? 'Unknown error';
      throw Exception('Failed to create devices: $error');
    }

    debugPrint('Created $count devices via edge function');
  }

  Future<void> updateDevice(Device device) async {
    await _client
        .from('devices')
        .update(_convertToSnakeCase(device.toJson()))
        .eq('id', device.id);
  }

  Future<void> deleteDevice(String id) async {
    await _client.from('devices').update({
      'is_deleted': true,
      'deleted_utc': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  // MARK: - ACCOUNTS

  Future<List<Account>> getAccounts() async {
    final response = await _client.from('accounts').select();

    return response
        .map((json) => Account.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<Account?> getAccountById(String id) async {
    final response =
        await _client.from('accounts').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return Account.fromJson(_convertFromSnakeCase(response));
  }

  Future<Account?> getAccountByEmail(String email) async {
    final response = await _client
        .from('accounts')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (response == null) return null;
    return Account.fromJson(_convertFromSnakeCase(response));
  }

  Future<List<Account>> getAccountsByCompanyId(String companyId) async {
    final response =
        await _client.from('accounts').select().eq('company_id', companyId);

    return response
        .map((json) => Account.fromJson(_convertFromSnakeCase(json)))
        .toList();
  }

  Future<void> updateAccount(Account account) async {
    await _client
        .from('accounts')
        .update(_convertToSnakeCase(account.toJson()))
        .eq('id', account.id);
  }

  Future<void> deleteAccount(String id) async {
    try {
      await Supabase.instance.client.rpc(
        'delete_user_account',
        params: {
          'target_user_id': id,
        },
      );
      debugPrint('User deleted from Auth and Public tables.');
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  // MARK: - Komplexne supabase

  Future<Map<String, int>> getCompanyStats(String companyId) async {
    final response = await _client
        .rpc('get_company_statistics', params: {'p_company_id': companyId});
    return Map<String, int>.from(response);
  }

  Future<Map<String, int>> getUserStats(String accountId) async {
    final response = await _client
        .rpc('get_user_access_statistics', params: {'p_account_id': accountId});
    return Map<String, int>.from(response);
  }

  Future<List<AccessKey>> getAccessKeysWithRelations(String companyId) async {
    final response = await _client.rpc(
      'get_company_accesses_with_relations',
      params: {'p_company_id': companyId},
    );
    return response
        .map<AccessKey>((e) => AccessKey.fromRpc(Map<String, dynamic>.from(e)))
        .toList();
  }

  // MARK: - HELPER METHODS

  Future<List<Building>> _hydrateBuildingsWithAccessKeys(
    List<Map<String, dynamic>> buildingJsons,
  ) async {
    if (buildingJsons.isEmpty) return [];
    final buildingIds = buildingJsons.map((j) => j['id'] as String).toList();
    final accessKeysResponse = await _client
        .from('access_keys')
        .select('id, building_id')
        .inFilter('building_id', buildingIds);
    final accessKeysByBuilding = <String, List<String>>{};
    for (final r in accessKeysResponse) {
      accessKeysByBuilding
          .putIfAbsent(r['building_id'] as String, () => [])
          .add(r['id'] as String);
    }
    return buildingJsons.map((json) {
      final converted = _convertFromSnakeCase(json);
      converted['accessKeyIds'] = accessKeysByBuilding[json['id']] ?? [];
      return Building.fromJson(converted);
    }).toList();
  }

  Future<List<AccessKey>> _hydrateAccessKeysWithRelations(
    List<Map<String, dynamic>> accessKeyJsons,
  ) async {
    if (accessKeyJsons.isEmpty) return [];
    final accessKeyIds = accessKeyJsons.map((j) => j['id'] as String).toList();
    final deviceAccessKeys = await _client
        .from('device_access_key')
        .select('access_key_id, device_id')
        .inFilter('access_key_id', accessKeyIds);
    final devicesByAccessKey = <String, List<String>>{};
    for (final dak in deviceAccessKeys) {
      devicesByAccessKey
          .putIfAbsent(dak['access_key_id'] as String, () => [])
          .add(dak['device_id'] as String);
    }
    return accessKeyJsons.map((json) {
      final converted = _convertFromSnakeCase(json);
      converted['deviceIds'] = devicesByAccessKey[json['id']] ?? [];
      return AccessKey.fromJson(converted);
    }).toList();
  }

  Map<String, dynamic> _convertToSnakeCase(Map<String, dynamic> data) {
    final converted = <String, dynamic>{};
    data.forEach((key, value) {
      final snakeKey = key.replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => '_${match.group(0)!.toLowerCase()}',
      );
      converted[snakeKey] = value;
    });
    return converted;
  }

  Map<String, dynamic> _convertFromSnakeCase(Map<String, dynamic> data) {
    final converted = <String, dynamic>{};
    data.forEach((key, value) {
      final camelKey = key.replaceAllMapped(
        RegExp(r'_([a-z])'),
        (match) => match.group(1)!.toUpperCase(),
      );
      converted[camelKey] = value;
    });
    return converted;
  }

  Future<Building> _convertBuildingFromSupabase(
    Map<String, dynamic> json,
  ) async {
    // Get accessKey IDs for this building
    final accessKeysResponse = await _client
        .from('access_keys')
        .select('id')
        .eq('building_id', json['id']);

    final accessKeyIds =
        accessKeysResponse.map((r) => r['id'] as String).toList();

    final convertedJson = _convertFromSnakeCase(json);
    convertedJson['accessKeyIds'] = accessKeyIds;

    return Building.fromJson(convertedJson);
  }

  Future<AccessKey> _convertAccessKeyFromSupabase(
    Map<String, dynamic> json,
  ) async {
    final accessKeyId = json['id'] as String;

    // Get device IDs for this access key
    final deviceAccessKeysResponse = await _client
        .from('device_access_key')
        .select('device_id')
        .eq('access_key_id', accessKeyId);

    final deviceIds = deviceAccessKeysResponse
        .map((dak) => dak['device_id'] as String)
        .toList();

    final convertedJson = _convertFromSnakeCase(json);
    convertedJson['deviceIds'] = deviceIds;

    return AccessKey.fromJson(convertedJson);
  }

  // MARK: - DEVICE UNLOCK FUNCTIONALITY

  Future<bool> unlockDevice(String deviceId) async {
    debugPrint('Attempting to unlock device: $deviceId');
    try {
      final response = await _client.functions.invoke(
        'unlock-device',
        body: {'device_id': deviceId},
      );

      if (response.status == 200) {
        debugPrint('Success: Door Unlocked!');
        return true;
      } else {
        debugPrint('Error: ${response.data}');
        return false;
      }
    } on FunctionException catch (e) {
      // Supabase-specific function errors
      debugPrint('Function Error: $e (Code: ${e.status})');
      return false;
    } catch (e) {
      debugPrint('Network Error: $e');
      return false;
    }
  }

  // MARK: - AUTHENTICATION (Additional methods for user management)

  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // Edge Function acc creation
  Future<void> createNewAccount({
    required String email,
    required String companyId,
    required String role,
  }) async {
    try {
      debugPrint('Attempting to create user: $email with role: $role...');

      final response = await _client.functions.invoke(
        'create-new-account',
        body: {
          'email': email,
          'company_id': companyId,
          'target_role': role,
        },
      );

      // Check for HTTP 200 OK
      // functions.invoke throws FunctionException on non-2xx errors usually, but checking status for simplicity.
      if (response.status == 200) {
        debugPrint('SUCCESS: User created.');
        final data = response.data;
        debugPrint("User ID: ${data['user']['id']}");
      }
    } on FunctionException catch (e) {
      // 400 (Bad Request) or 403 (Unauthorized) from the Edge Function
      debugPrint('FUNCTION ERROR: $e');
    } catch (e) {
      debugPrint('NETWORK/UNEXPECTED ERROR: $e');
    }
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
