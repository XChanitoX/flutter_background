import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../db/isar_config.dart';
import '../models/ejemplar.dart';

// Cambiar a FutureProvider para manejar la asincronía
final isarProvider = FutureProvider<Isar>((ref) async {
  return await openIsar();
});

// Actualizar para depender de FutureProvider
final ejemplarProvider = StreamProvider<List<Ejemplar>>((ref) async* {
  final isar = await ref.watch(isarProvider.future);
  yield* isar.ejemplars.where().watch(fireImmediately: true);
});
