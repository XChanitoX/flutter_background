import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ui/home_page.dart';
import 'services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Solicitar permisos necesarios para el servicio en segundo plano
  await _requestPermissions();

  runApp(const ProviderScope(child: MyApp()));
  initializeService(); // Inicia la sincronización
}

Future<void> _requestPermissions() async {
  // Solicitar permiso para notificaciones
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Solicitar permiso para alarmas exactas (Android 12+)
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ejemplares Sincronizados',
      home: HomePage(),
    );
  }
}
