class Building {
  Building({
    required this.id,
    required this.name,
    required this.address,
    required this.areaId,
    required this.companyId,
    required this.accessKeyIds,
    required this.createdUtc,
    required this.updatedUtc,
    this.isDeleted = false,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      areaId: json['areaId'],
      companyId: json['companyId'],
      accessKeyIds: List<String>.from(json['accessKeyIds'] ?? []),
      createdUtc: DateTime.parse(json['createdUtc']),
      updatedUtc: DateTime.parse(json['updatedUtc']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  final String id;
  final String name;
  final String address;
  final String areaId;
  final String companyId;
  final List<String> accessKeyIds;
  final DateTime createdUtc;
  final DateTime updatedUtc;
  final bool isDeleted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'areaId': areaId,
      'companyId': companyId,
      'accessKeyIds': accessKeyIds,
      'createdUtc': createdUtc.toIso8601String(),
      'updatedUtc': updatedUtc.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  Building copyWith({
    String? id,
    String? name,
    String? address,
    String? areaId,
    String? companyId,
    List<String>? accessKeyIds,
    DateTime? createdUtc,
    DateTime? updatedUtc,
    bool? isDeleted,
  }) {
    return Building(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      areaId: areaId ?? this.areaId,
      companyId: companyId ?? this.companyId,
      accessKeyIds: accessKeyIds ?? this.accessKeyIds,
      createdUtc: createdUtc ?? this.createdUtc,
      updatedUtc: updatedUtc ?? this.updatedUtc,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
