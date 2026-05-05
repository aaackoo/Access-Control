import 'package:access_control/core/providers/areas_providers.dart';
import 'package:access_control/features/widgets/general_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreasHeader extends ConsumerWidget {
  const AreasHeader({
    super.key,
    required this.selectedCompany,
  });

  final String? selectedCompany;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areasAsync = selectedCompany != null
        ? ref.watch(areasByCompanyIdProvider(selectedCompany!))
        : const AsyncValue.data(<dynamic>[]);
    return GeneralHeader(
      async: areasAsync,
      icon: Icons.location_city_outlined,
      type: HeaderType.area,
    );
  }
}
