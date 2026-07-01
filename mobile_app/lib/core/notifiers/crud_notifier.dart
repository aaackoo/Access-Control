import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CrudNotifier<T> extends StateNotifier<AsyncValue<List<T>>> {
  CrudNotifier(this.ref) : super(const AsyncValue.loading()) {
    _load();
  }

  final Ref ref;

  Future<List<T>> fetchData();

  Future<void> _load() async {
    state = await AsyncValue.guard(fetchData);
  }

  Future<void> mutate(Future<void> Function() action) async {
    try {
      await action();
      await _load();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void refresh() => _load();

  Future<void> clearData() async {
    state = const AsyncValue.data([]);
  }
}
