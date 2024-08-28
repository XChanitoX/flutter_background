import 'package:flutter/material.dart';
import 'package:flutter_background/models/ejemplar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/isar_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ejemplaresAsyncValue = ref.watch(ejemplarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ejemplares Sincronizados"),
      ),
      body: ejemplaresAsyncValue.when(
        data: (ejemplares) {
          if (ejemplares.isEmpty) {
            return const Center(
              child: Text("No hay ejemplares sincronizados."),
            );
          }
          return ListView.builder(
            itemCount: ejemplares.length,
            itemBuilder: (context, index) {
              final ejemplar = ejemplares[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    ejemplar.nombre,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Cargando ejemplares..."),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 20),
              Text(
                'Error al cargar ejemplares:\n$err',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final _ = ref.refresh(ejemplarProvider); // Permite reintentar
                },
                child: const Text("Reintentar"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final isar = await ref.read(isarProvider.future);
          await isar.writeTxn(() async {
            await isar.ejemplars.clear(); // Limpia todos los registros
          });
          // Refresca el provider para actualizar la UI
          final _ = ref.refresh(ejemplarProvider);
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.delete),
      ),
    );
  }
}
