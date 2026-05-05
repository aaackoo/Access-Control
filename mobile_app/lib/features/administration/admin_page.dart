import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/providers/state_management_providers.dart';
import 'package:access_control/features/administration/areas_tab/areas_tab_widget.dart';
import 'package:access_control/features/administration/areas_tab/widgets/add_area_modal.dart';
import 'package:access_control/features/administration/buildings_tab/buildings_tab_widget.dart';
import 'package:access_control/features/administration/buildings_tab/widgets/add_building_modal.dart';
import 'package:access_control/features/administration/companies_tab/companies_tab_widget.dart';
import 'package:access_control/features/administration/devices_tab/devices_tab_widget.dart';
import 'package:access_control/features/administration/devices_tab/widgets/add_device_modal.dart';
import 'package:access_control/features/widgets/general_add_button.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextTab() {
    _tabController.animateTo(_tabController.index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: ACColors.backgroundDimmed,
            child: TabBar(
              indicatorColor: ACColors.accent,
              labelColor: ACColors.accent,
              unselectedLabelColor: ACColors.primaryShade,
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(
                  icon: const Icon(Icons.business),
                  text: context.l10n.company,
                ),
                Tab(
                  icon: const Icon(Icons.location_city),
                  text: context.l10n.areas,
                ),
                Tab(
                  icon: const Icon(Icons.apartment),
                  text: context.l10n.buildings,
                ),
                Tab(
                  icon: const Icon(Icons.devices),
                  text: context.l10n.devices,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CompaniesTabWidget(onChangeTab: _nextTab),
                AreasTabWidget(onChangeTab: _nextTab),
                BuildingsTabWidget(onChangeTab: _nextTab),
                DevicesTabWidget(onChangeTab: _nextTab),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_tabController.index == 0) return null;

    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedArea = ref.watch(selectedAreaProvider);
    final selectedBuilding = ref.watch(selectedBuildingProvider);

    if (_tabController.index == 1) {
      return GeneralAddButton(
        title: context.l10n.addArea,
        icon: Icons.location_city,
        onTap: selectedCompany != null
            ? () => showDialog(
                  context: context,
                  builder: (context) =>
                      AddAreaModal(companyId: selectedCompany),
                )
            : null,
      );
    } else if (_tabController.index == 2) {
      final isEnabled = selectedCompany != null && selectedArea != null;
      return GeneralAddButton(
        title: context.l10n.addBuilding,
        icon: Icons.apartment,
        onTap: isEnabled
            ? () => showDialog(
                  context: context,
                  builder: (context) => AddBuildingModal(
                    companyId: selectedCompany,
                    areaId: selectedArea,
                  ),
                )
            : null,
      );
    } else if (_tabController.index == 3) {
      final isEnabled = selectedCompany != null && selectedBuilding != null;
      return GeneralAddButton(
        title: context.l10n.addDevice,
        icon: Icons.devices,
        onTap: isEnabled
            ? () => showDialog(
                  context: context,
                  builder: (context) =>
                      AddDeviceModal(companyId: selectedCompany),
                )
            : null,
      );
    }

    return null;
  }
}
