import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';

enum AccountRole {
  user,
  manager,
  owner;

  static AccountRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'manager':
        return AccountRole.manager;
      case 'owner':
        return AccountRole.owner;
      case 'user':
        return AccountRole.user;
      default:
        throw ArgumentError('Unknown AccountRole: $value');
    }
  }
}

extension AccountRoleX on AccountRole {
  String get roleString {
    switch (this) {
      case AccountRole.owner:
        return 'owner';
      case AccountRole.manager:
        return 'manager';
      case AccountRole.user:
        return 'user';
    }
  }
}

extension AccountRoleColor on AccountRole {
  Color get color {
    switch (this) {
      case AccountRole.owner:
        return ACColors.primary.withValues(alpha: 0.2);
      case AccountRole.manager:
        return ACColors.secondary.withValues(alpha: 0.2);
      case AccountRole.user:
        return ACColors.backgroundAccent;
    }
  }
}

String accountRoleToString(BuildContext context, AccountRole role) {
  switch (role) {
    case AccountRole.user:
      return context.l10n.user;
    case AccountRole.manager:
      return context.l10n.manager;
    case AccountRole.owner:
      return context.l10n.companyOwner;
  }
}

class Account {
  Account({
    required this.id,
    required this.email,
    required this.role,
    required this.companyId,
    required this.createdUtc,
    required this.updatedUtc,
    this.isDeleted = false,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      email: json['email'],
      role: AccountRole.fromString(json['role']),
      companyId: json['companyId'],
      createdUtc: DateTime.parse(json['createdUtc']),
      updatedUtc: DateTime.parse(json['updatedUtc']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  final String id;
  final String email;
  final AccountRole role;
  final String companyId;
  final DateTime createdUtc;
  final DateTime updatedUtc;
  final bool isDeleted;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.roleString,
      'companyId': companyId,
      'createdUtc': createdUtc.toIso8601String(),
      'updatedUtc': updatedUtc.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  Account copyWith({
    String? id,
    String? email,
    AccountRole? role,
    String? companyId,
    DateTime? createdUtc,
    DateTime? updatedUtc,
    bool? isDeleted,
  }) {
    return Account(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      companyId: companyId ?? this.companyId,
      createdUtc: createdUtc ?? this.createdUtc,
      updatedUtc: updatedUtc ?? this.updatedUtc,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
