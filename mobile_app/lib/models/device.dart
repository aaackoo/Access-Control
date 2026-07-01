import 'package:access_control/core/constants/ac_colors.dart';
import 'package:flutter/material.dart';

enum DeviceType {
  door,
  gate,
  turnstile,
  ramp,
}

extension DeviceTypeX on DeviceType {
  Color get color {
    switch (this) {
      case DeviceType.door:
        return ACColors.primary;
      case DeviceType.gate:
        return ACColors.primary;
      case DeviceType.turnstile:
        return ACColors.primary;
      case DeviceType.ramp:
        return ACColors.primary;
    }
  }

  IconData get icon {
    switch (this) {
      case DeviceType.door:
        return Icons.door_front_door;
      case DeviceType.gate:
        return Icons.door_front_door;
      case DeviceType.turnstile:
        return Icons.door_front_door;
      case DeviceType.ramp:
        return Icons.door_front_door;
    }
  }

  String get label {
    switch (this) {
      case DeviceType.door:
        return 'Dvere';
      case DeviceType.gate:
        return 'Brána';
      case DeviceType.turnstile:
        return 'Turniket';
      case DeviceType.ramp:
        return 'Rampa';
    }
  }
}

class Device {
  Device({
    required this.id,
    required this.name,
    required this.deviceType,
    required this.companyId,
    required this.buildingId,
    required this.createdUtc,
    required this.updatedUtc,
    this.isDeleted = false,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      deviceType: _parseDeviceType(json['type'] as String? ?? 'door'),
      companyId: json['companyId'],
      buildingId: json['buildingId'] ?? '',
      createdUtc: DateTime.parse(json['createdUtc']),
      updatedUtc: DateTime.parse(json['updatedUtc']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  static DeviceType _parseDeviceType(String type) {
    switch (type) {
      case 'gate':
        return DeviceType.gate;
      case 'turnstile':
        return DeviceType.turnstile;
      case 'ramp':
        return DeviceType.ramp;
      default:
        return DeviceType.door;
    }
  }

  static String getStringFromDeviceType(DeviceType type) {
    switch (type) {
      case DeviceType.door:
        return 'door';
      case DeviceType.gate:
        return 'gate';
      case DeviceType.turnstile:
        return 'turnstile';
      case DeviceType.ramp:
        return 'ramp';
    }
  }

  final String id;
  final String name;
  final DeviceType deviceType;
  final String companyId;
  final String buildingId;
  final DateTime createdUtc;
  final DateTime updatedUtc;
  final bool isDeleted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': getStringFromDeviceType(deviceType),
      'companyId': companyId,
      'buildingId': buildingId,
      'createdUtc': createdUtc.toIso8601String(),
      'updatedUtc': updatedUtc.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  Device copyWith({
    String? id,
    String? name,
    DeviceType? deviceType,
    String? companyId,
    String? buildingId,
    DateTime? createdUtc,
    DateTime? updatedUtc,
    bool? isDeleted,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceType: deviceType ?? this.deviceType,
      companyId: companyId ?? this.companyId,
      buildingId: buildingId ?? this.buildingId,
      createdUtc: createdUtc ?? this.createdUtc,
      updatedUtc: updatedUtc ?? this.updatedUtc,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
