import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/companies_tab/edit_company_modal.dart';
import 'package:access_control/features/widgets/modal_actions.dart';
import 'package:access_control/models/company.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyListTile extends ConsumerWidget {
  const CompanyListTile({
    super.key,
    required this.company,
    required this.isSelected,
    required this.onChangeTab,
  });

  final Company company;
  final bool isSelected;
  final VoidCallback onChangeTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isSelected ? ACColors.backgroundAccent : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(selectedCompanyProvider.notifier).state = company.id;
          ref.read(selectedAreaProvider.notifier).state = null;
          ref.read(selectedBuildingProvider.notifier).state = null;
          onChangeTab();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient:
                      isSelected ? null : ACGradients.accentPrimaryGradient,
                  color: isSelected ? ACColors.accent : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: ACColors.backgroundAccent,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    company.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  company.name,
                  style: ACTextStyles.bodyText(ACColors.text).copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.check_circle, color: ACColors.accent),
                ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  editMenuItem(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => EditCompanyModal(company: company),
                    ),
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
