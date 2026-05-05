class Area {
  Area({
    required this.id,
    required this.name,
    required this.location,
    required this.companyId,
    required this.createdUtc,
    required this.updatedUtc,
    this.isDeleted = false,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      companyId: json['companyId'],
      createdUtc: DateTime.parse(json['createdUtc']),
      updatedUtc: DateTime.parse(json['updatedUtc']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  final String id;
  final String name;
  final String location;
  final String companyId;
  final DateTime createdUtc;
  final DateTime updatedUtc;
  final bool isDeleted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'companyId': companyId,
      'createdUtc': createdUtc.toIso8601String(),
      'updatedUtc': updatedUtc.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  Area copyWith({
    String? id,
    String? name,
    String? location,
    String? companyId,
    DateTime? createdUtc,
    DateTime? updatedUtc,
    bool? isDeleted,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      companyId: companyId ?? this.companyId,
      createdUtc: createdUtc ?? this.createdUtc,
      updatedUtc: updatedUtc ?? this.updatedUtc,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
