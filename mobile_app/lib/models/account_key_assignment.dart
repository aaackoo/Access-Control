import 'package:access_control/models/access_key.dart';

class AccountKeyAssignment {
  const AccountKeyAssignment({
    required this.accessKey,
    this.grantedBy,
    this.validFromUtc,
    this.validToUtc,
  });

  final AccessKey accessKey;
  final String? grantedBy;
  final DateTime? validFromUtc;
  final DateTime? validToUtc;

  bool get isActive {
    final now = DateTime.now().toUtc();
    final afterStart = validFromUtc == null || now.isAfter(validFromUtc!);
    final beforeEnd = validToUtc == null || now.isBefore(validToUtc!);
    return afterStart && beforeEnd;
  }
}
