import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sync_provider.dart';

Future<void> initializeService(BuildContext context) async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true, // Asegurarse de que esté en modo primer plano
      autoStart: true,
    ),
  );

  // Inicia el servicio automáticamente al inicializar
  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    final container = ProviderContainer();
    final syncNotifier = container.read(syncProvider.notifier);

    if (syncNotifier.isSyncing) {
      service.setForegroundNotificationInfo(
        title: "Sincronizando ejemplares",
        content: "El servicio está sincronizando tus datos.",
      );
    } else {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Sincronizando ejemplares",
          content: "El servicio está sincronizando tus datos.",
        );

        await syncNotifier.startSync((item) {
          service.setForegroundNotificationInfo(
            title: "Sincronizando ejemplares",
            content: "Sincronizando: $item",
          );
        });

        service.stopSelf();
      }
    }

    print('Background service running');
    service.invoke('update');
  }
}
