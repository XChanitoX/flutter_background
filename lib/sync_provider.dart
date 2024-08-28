import 'package:flutter_riverpod/flutter_riverpod.dart';

class SyncNotifier extends StateNotifier<List<String>> {
  SyncNotifier() : super([]);

  bool _isSyncing = false;

  bool get isSyncing => _isSyncing;

  Future<void> startSync(Function(String) onItemSynced) async {
    if (_isSyncing)
      return; // Evitar que se inicie otra sincronización si ya hay una en curso

    _isSyncing = true;
    state = []; // Limpiar la lista de ítems sincronizados

    List<String> itemsToSync = [
      "Item 1",
      "Item 2",
      "Item 3",
      "Item 4",
      "Item 5"
    ];

    for (String item in itemsToSync) {
      await Future.delayed(const Duration(seconds: 3));
      state = [...state, item]; // Actualizar el estado con el nuevo ítem
      onItemSynced(item); // Notifica el progreso de sincronización
    }

    _isSyncing = false;
    state = [...state]; // Forzar la actualización final del estado
  }

  void addItem(String item) {
    state = [...state, item]; // Añadir un ítem a la lista sincronizada
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, List<String>>((ref) {
  return SyncNotifier();
});
