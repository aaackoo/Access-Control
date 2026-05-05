import 'package:access_control/core/providers/companies_providers.dart';
import 'package:access_control/features/administration/companies_tab/widgets/company_list_tile.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompaniesList extends ConsumerWidget {
  const CompaniesList({
    super.key,
    required this.companiesAsync,
    required this.selectedCompany,
    required this.onChangeTab,
  });

  final AsyncValue<List<Company>> companiesAsync;
  final String? selectedCompany;
  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return companiesAsync.when(
      data: (companies) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(companiesNotifierProvider),
        child: companies.isEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: GeneralEmptyState(
                    icon: Icons.business_outlined,
                    title: context.l10n.noOwners,
                    subtitle: context.l10n.noOwnersSubtitle,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return CompanyListTile(
                    company: companies[index],
                    isSelected: selectedCompany == companies[index].id,
                    onChangeTab: onChangeTab,
                  );
                },
              ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => GeneralErrorState(
        error: error,
        onRetry: () => ref.invalidate(companiesNotifierProvider),
      ),
    );
  }
}
