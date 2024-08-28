import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_provider.dart';
import 'background_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    initializeService(context); // Inicia el servicio al abrir la app
  }

  @override
  Widget build(BuildContext context) {
    final syncItems =
        ref.watch(syncProvider); // Escuchar la lista de ítems sincronizados
    final syncNotifier = ref.watch(syncProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sincronización de Ejemplares"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (syncNotifier.isSyncing) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Sincronizando...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              const Center(
                child: Text(
                  "Sincronización completada",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (syncItems.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: syncItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                        ),
                        title: Text(
                          syncItems[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Ejemplar ${index + 1}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (!syncNotifier.isSyncing)
              const Center(
                child: Text(
                  "No hay ítems sincronizados.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
