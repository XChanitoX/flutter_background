import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncedItemsProvider =
    StateNotifierProvider<SyncedItemsNotifier, List<String>>((ref) {
  return SyncedItemsNotifier();
});

class SyncedItemsNotifier extends StateNotifier<List<String>> {
  SyncedItemsNotifier() : super([]);

  void addItem(String item) {
    state = [...state, item];
  }

  void reset() {
    state = [];
  }
}
