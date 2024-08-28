import 'package:flutter_riverpod/flutter_riverpod.dart'; // Maneja el estado de la app con providers reactivos.
import 'package:isar/isar.dart'; // Biblioteca para manejar la base de datos local Isar.
import '../models/ejemplar.dart'; // Modelo de datos Ejemplar, que representa la estructura de los registros en Isar.
import '../db/isar_singleton.dart'; // Importa el Singleton

final isarProvider = FutureProvider<Isar>((ref) async {
  return await IsarInstance.getInstance();
});

// Provider que observa la colección de Ejemplares en la base de datos y proporciona una lista actualizada.
final ejemplarProvider = StreamProvider<List<Ejemplar>>((ref) async* {
  // Espera a que isarProvider proporcione la instancia de Isar.
  final isar = await ref.watch(isarProvider.future);

  // Observa los cambios en la colección de ejemplares y actualiza automáticamente la UI.
  yield* isar.ejemplars.where().watch(fireImmediately: true);
});
