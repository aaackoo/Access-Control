import 'package:access_control/core/providers/companies_providers.dart';
import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/companies_tab/widgets/companies_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompaniesTabWidget extends ConsumerWidget {
  const CompaniesTabWidget({
    super.key,
    required this.onChangeTab,
  });

  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(companiesNotifierProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);

    return Column(
      children: [
        Expanded(
          child: CompaniesList(
            companiesAsync: companiesAsync,
            selectedCompany: selectedCompany,
            onChangeTab: onChangeTab,
          ),
        ),
      ],
    );
  }
}
