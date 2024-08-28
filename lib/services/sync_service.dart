import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../db/isar_config.dart';
import '../models/ejemplar.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<bool> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final isar = await openIsar();

  // Configurar el canal de notificación
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'my_foreground', // ID del canal
    'Foreground Service', // Nombre del canal
    channelDescription:
        'Canal para el servicio en primer plano', // Descripción del canal
    importance: Importance.low, // Importancia de la notificación
    priority: Priority.low, // Prioridad de la notificación
    ongoing: true, // Indica que la notificación es continua
    showWhen: false, // Ocultar la hora de la notificación
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Mostrar la notificación inicial
  await flutterLocalNotificationsPlugin.show(
    888,
    'Sincronizando Ejemplares',
    'Preparando la sincronización...',
    platformChannelSpecifics,
  );

  // Simulación del proceso de sincronización
  List<String> itemsToSync = [
    "Ejemplar A",
    "Ejemplar B",
    "Ejemplar C",
  ];

  for (var nombre in itemsToSync) {
    await Future.delayed(const Duration(seconds: 5));
    await isar.writeTxn(() async {
      final ejemplar = Ejemplar(nombre: nombre);
      await isar.ejemplars.put(ejemplar);
    });

    // Actualizar la notificación con el nombre del ejemplar sincronizado
    await flutterLocalNotificationsPlugin.show(
      888,
      'Sincronizando Ejemplares',
      'Sincronizando: $nombre',
      platformChannelSpecifics,
    );
  }

  // Cancelar la notificación al finalizar
  await flutterLocalNotificationsPlugin.cancel(888);

  service.stopSelf();

  return true; // Indicar que el servicio se inició correctamente
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_notification');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
