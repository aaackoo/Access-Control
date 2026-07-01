import 'package:access_control/core/constants/ac_colors.dart';
import 'package:access_control/core/constants/ac_text_styles.dart';
import 'package:access_control/core/providers/access_keys_providers.dart';
import 'package:access_control/core/providers/auth_provider.dart';
import 'package:access_control/core/providers/home_screen_providers.dart';
import 'package:access_control/core/providers/supabase_database_provider.dart';
import 'package:access_control/features/widgets/general_empty_state.dart';
import 'package:access_control/features/widgets/general_error_state.dart';
import 'package:access_control/l10n/extension.dart';
import 'package:access_control/models/account.dart';
import 'package:access_control/models/account_key_assignment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccessRightsCard extends ConsumerStatefulWidget {
  const AccessRightsCard({super.key, required this.account});

  final Account account;

  @override
  ConsumerState<AccessRightsCard> createState() => _AccessRightsCardState();
}

class _AccessRightsCardState extends ConsumerState<AccessRightsCard> {
  bool _isLoading = false;

  Future<void> _assign(String accessKeyId) async {
    final validity = await _showValidityDialog(context);
    if (validity == null) return;

    setState(() => _isLoading = true);
    try {
      final currentUserId = ref.read(currentUserProvider).value?.id ?? '';
      await ref.read(supabaseDatabaseProvider).assignAccessKeyToAccount(
            widget.account.id,
            accessKeyId,
            grantedBy: currentUserId,
            validFromUtc: validity.validFrom,
            validToUtc: validity.validTo,
          );
      ref
        ..invalidate(accountKeyAssignmentsProvider(widget.account.id))
        ..invalidate(currentUserKeysProvider)
        ..invalidate(userKeysStatsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringAddingAccessKey),
            backgroundColor: ACColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _remove(String accessKeyId) async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(supabaseDatabaseProvider)
          .removeAccessKeyFromAccount(widget.account.id, accessKeyId);
      ref
        ..invalidate(accountKeyAssignmentsProvider(widget.account.id))
        ..invalidate(currentUserKeysProvider)
        ..invalidate(userKeysStatsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringRemovingAccessKey),
            backgroundColor: ACColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editValidity(AccountKeyAssignment assignment) async {
    final validity = await _showValidityDialog(
      context,
      initial: _ValidityResult(
        validFrom: assignment.validFromUtc?.toLocal(),
        validTo: assignment.validToUtc?.toLocal(),
      ),
    );
    if (validity == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(supabaseDatabaseProvider).updateAccessKeyAssignment(
            widget.account.id,
            assignment.accessKey.id,
            validFromUtc: validity.validFrom,
            validToUtc: validity.validTo,
          );
      ref.invalidate(accountKeyAssignmentsProvider(widget.account.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorDuringUpdatingAccessKeyValidity),
            backgroundColor: ACColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<_ValidityResult?> _showValidityDialog(
    BuildContext context, {
    _ValidityResult? initial,
  }) {
    return showDialog<_ValidityResult>(
      context: context,
      builder: (context) => _ValidityDialog(initial: initial),
    );
  }

  void _showAddAccessKeySheet(Set<String> assignedKeyIds) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddAccessKeySheet(
        account: widget.account,
        assignedKeyIds: assignedKeyIds,
        onAssign: _assign,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignmentsAsync =
        ref.watch(accountKeyAssignmentsProvider(widget.account.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.accessKeys,
                  style: ACTextStyles.appBarTitle(ACColors.text),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  assignmentsAsync.whenData((assignments) {
                        return TextButton.icon(
                          onPressed: () => _showAddAccessKeySheet(
                            assignments.map((a) => a.accessKey.id).toSet(),
                          ),
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: ACColors.accent,
                          ),
                          label: Text(
                            context.l10n.add,
                            style: ACTextStyles.bodyText(ACColors.accent),
                          ),
                        );
                      }).value ??
                      TextButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                          color: ACColors.accent,
                        ),
                        label: Text(
                          context.l10n.add,
                          style: ACTextStyles.bodyText(ACColors.accent),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 12),
            assignmentsAsync.when(
              data: (assignments) {
                if (assignments.isEmpty) {
                  return GeneralEmptyState(
                    icon: Icons.key_off,
                    title: context.l10n.noAccessKeys,
                    subtitle: context.l10n.addNewAccessKeys,
                  );
                }
                return Column(
                  children: assignments
                      .map(
                        (assignment) => _AssignedKeyTile(
                          assignment: assignment,
                          onRemove: () => _remove(assignment.accessKey.id),
                          onEditValidity: () => _editValidity(assignment),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => GeneralErrorState(error: e),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssignedKeyTile extends StatelessWidget {
  const _AssignedKeyTile({
    required this.assignment,
    required this.onRemove,
    required this.onEditValidity,
  });

  final AccountKeyAssignment assignment;
  final VoidCallback onRemove;
  final VoidCallback onEditValidity;

  @override
  Widget build(BuildContext context) {
    final isActive = assignment.isActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ACColors.backgroundAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.credit_card, color: ACColors.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.accessKey.name,
                  style: ACTextStyles.bodyText(ACColors.text),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? ACColors.success : ACColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? context.l10n.active : context.l10n.inactive,
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive ? ACColors.success : ACColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  context.l10n
                      .assignedDevices(assignment.accessKey.deviceIds.length),
                  style: ACTextStyles.smallerBodyText(ACColors.textDim),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEditValidity,
            icon: const Icon(
              Icons.edit_calendar_outlined,
              color: ACColors.textDim,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              Icons.remove_circle_outline,
              color: ACColors.error,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _ValidityResult {
  const _ValidityResult({this.validFrom, this.validTo});
  final DateTime? validFrom;
  final DateTime? validTo;
}

class _ValidityDialog extends StatefulWidget {
  const _ValidityDialog({this.initial});
  final _ValidityResult? initial;

  @override
  State<_ValidityDialog> createState() => _ValidityDialogState();
}

class _ValidityDialogState extends State<_ValidityDialog> {
  DateTime? _validFrom;
  DateTime? _validTo;

  @override
  void initState() {
    super.initState();
    _validFrom = widget.initial?.validFrom;
    _validTo = widget.initial?.validTo;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _validFrom : _validTo) ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: ACColors.background,
            headerBackgroundColor: ACColors.primary,
            headerForegroundColor: ACColors.white,
            dividerColor: ACColors.backgroundDimmed,
            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return ACColors.white;
              if (states.contains(WidgetState.disabled)) {
                return ACColors.textDim;
              }
              return ACColors.text;
            }),
            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ACColors.primary;
              }
              return Colors.transparent;
            }),
            todayForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return ACColors.white;
              return ACColors.primary;
            }),
            todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ACColors.primary;
              }
              return Colors.transparent;
            }),
            todayBorder: const BorderSide(color: ACColors.primary),
            yearForegroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) return ACColors.white;
              if (states.contains(WidgetState.disabled)) {
                return ACColors.textDim;
              }
              return ACColors.text;
            }),
            yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ACColors.primary;
              }
              return Colors.transparent;
            }),
            cancelButtonStyle:
                TextButton.styleFrom(foregroundColor: ACColors.textDim),
            confirmButtonStyle:
                TextButton.styleFrom(foregroundColor: ACColors.primary),
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _validFrom = picked;
      } else {
        _validTo = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.accessValidity),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DateRow(
            label: context.l10n.validFrom,
            value: _formatDate(_validFrom),
            onTap: () => _pickDate(isFrom: true),
            onClear: _validFrom != null
                ? () => setState(() => _validFrom = null)
                : null,
          ),
          const SizedBox(height: 12),
          _DateRow(
            label: context.l10n.validTo,
            value: _formatDate(_validTo),
            onTap: () => _pickDate(isFrom: false),
            onClear:
                _validTo != null ? () => setState(() => _validTo = null) : null,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => context.pop(
            _ValidityResult(
              validFrom: _validFrom,
              validTo: _validTo,
            ),
          ),
          child: Text(context.l10n.confirm),
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: ACColors.textDim),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ACColors.text.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: ACColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(value, style: ACTextStyles.bodyText(ACColors.text)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (onClear != null) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.clear, size: 18, color: ACColors.textDim),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ],
    );
  }
}

class _AddAccessKeySheet extends ConsumerWidget {
  const _AddAccessKeySheet({
    required this.account,
    required this.assignedKeyIds,
    required this.onAssign,
  });

  final Account account;
  final Set<String> assignedKeyIds;
  final Future<void> Function(String accessKeyId) onAssign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allKeysAsync = ref.watch(accessKeysNotifierProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: ACColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
                child: Row(
                  children: [
                    Text(
                      context.l10n.assignAccessKey,
                      style: ACTextStyles.appBarTitle(ACColors.text),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close, color: ACColors.text),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: allKeysAsync.when(
                  data: (keys) {
                    final available = keys
                        .where(
                          (k) => !k.isDeleted && !assignedKeyIds.contains(k.id),
                        )
                        .toList();

                    if (available.isEmpty) {
                      return GeneralEmptyState(
                        icon: Icons.key_off,
                        title: context.l10n.noAvailableAccessKeys,
                        subtitle: context.l10n.allAccessKeysAssigned,
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: available.length,
                      itemBuilder: (context, index) {
                        final key = available[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: ACColors.backgroundAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.credit_card,
                              color: ACColors.accent,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            key.name,
                            style: ACTextStyles.bodyText(ACColors.text),
                          ),
                          subtitle: Text(
                            context.l10n.assignedDevices(key.deviceIds.length),
                            style:
                                ACTextStyles.smallerBodyText(ACColors.textDim),
                          ),
                          trailing: const Icon(
                            Icons.add_circle_outline,
                            color: ACColors.accent,
                          ),
                          onTap: () async {
                            context.pop();
                            await onAssign(key.id);
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => GeneralErrorState(error: e),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
