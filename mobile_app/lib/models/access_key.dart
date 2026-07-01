class AccessKey {
  AccessKey({
    required this.id,
    required this.name,
    required this.companyId,
    required this.buildingId,
    required this.deviceIds,
    required this.createdUtc,
    required this.updatedUtc,
    this.isDeleted = false,
  });

  factory AccessKey.fromJson(Map<String, dynamic> json) {
    return AccessKey(
      id: json['id'],
      name: json['name'],
      companyId: json['companyId'],
      buildingId: json['buildingId'],
      deviceIds: List<String>.from(json['deviceIds'] ?? []),
      createdUtc: DateTime.parse(json['createdUtc']),
      updatedUtc: DateTime.parse(json['updatedUtc']),
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  factory AccessKey.fromRpc(Map<String, dynamic> json) {
    return AccessKey(
      id: json['key_id'],
      name: json['key_name'],
      companyId: json['company_id'],
      buildingId: json['building_id'],
      deviceIds: List<String>.from(json['device_ids'] ?? []),
      createdUtc: DateTime.parse(json['created_utc']),
      updatedUtc: DateTime.parse(json['updated_utc']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  final String id;
  final String name;
  final String companyId;
  final String buildingId;
  final List<String> deviceIds;
  final DateTime createdUtc;
  final DateTime updatedUtc;
  final bool isDeleted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'companyId': companyId,
      'buildingId': buildingId,
      'deviceIds': deviceIds,
      'createdUtc': createdUtc.toIso8601String(),
      'updatedUtc': updatedUtc.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  AccessKey copyWith({
    String? id,
    String? name,
    String? companyId,
    String? buildingId,
    List<String>? deviceIds,
    DateTime? createdUtc,
    DateTime? updatedUtc,
    bool? isDeleted,
  }) {
    return AccessKey(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      buildingId: buildingId ?? this.buildingId,
      deviceIds: deviceIds ?? this.deviceIds,
      createdUtc: createdUtc ?? this.createdUtc,
      updatedUtc: updatedUtc ?? this.updatedUtc,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
