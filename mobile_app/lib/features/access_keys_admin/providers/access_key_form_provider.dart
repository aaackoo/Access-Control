import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessKeyFormState {
  AccessKeyFormState({
    Set<String>? selectedDeviceIds,
    Set<String>? selectedKeyIds,
  })  : selectedDeviceIds = selectedDeviceIds ?? {},
        selectedKeyIds = selectedKeyIds ?? {};

  final Set<String> selectedDeviceIds;
  final Set<String> selectedKeyIds;

  AccessKeyFormState copyWith({
    Set<String>? selectedDeviceIds,
    Set<String>? selectedKeyIds,
  }) {
    return AccessKeyFormState(
      selectedDeviceIds: selectedDeviceIds ?? this.selectedDeviceIds,
      selectedKeyIds: selectedKeyIds ?? this.selectedKeyIds,
    );
  }
}

class AccessKeyFormNotifier extends StateNotifier<AccessKeyFormState> {
  AccessKeyFormNotifier() : super(AccessKeyFormState());

  void setSelectedDevices(Set<String> deviceIds) {
    state = state.copyWith(selectedDeviceIds: deviceIds);
  }

  void setSelectedKeys(Set<String> keyIds) {
    state = state.copyWith(selectedKeyIds: keyIds);
  }

  void reset() {
    state = AccessKeyFormState();
  }
}

final accessKeyFormProvider =
    StateNotifierProvider<AccessKeyFormNotifier, AccessKeyFormState>((ref) {
  return AccessKeyFormNotifier();
});
