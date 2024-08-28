import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../db/isar_config.dart';
import '../models/ejemplar.dart';

@pragma('vm:entry-point')
Future<bool> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final isar = await openIsar();

  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Configura la notificación para el servicio en primer plano
    service.setForegroundNotificationInfo(
      title: 'Sincronizando Ejemplares',
      content: 'Preparando la sincronización...',
    );
  }

  // Simulación del proceso de sincronización
  List<String> itemsToSync = [
    "Ejemplar A",
    "Ejemplar B",
    "Ejemplar C",
  ];

  for (var nombre in itemsToSync) {
    await Future.delayed(const Duration(seconds: 2));
    await isar.writeTxn(() async {
      final ejemplar = Ejemplar(nombre: nombre);
      await isar.ejemplars.put(ejemplar);
    });

    // Actualizar la notificación durante la sincronización
    service.invoke(
      'update',
      {
        'title': "Sincronizando Ejemplares",
        'content': "Sincronizando: $nombre"
      },
    );
  }

  service.stopSelf();

  return true; // Indicar que el servicio se inició correctamente
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: (service) => onStart(service),
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Sincronizando Ejemplares',
      initialNotificationContent: 'Preparando la sincronización...',
      foregroundServiceNotificationId: 888,
    ),
  );

  service.startService();
}
