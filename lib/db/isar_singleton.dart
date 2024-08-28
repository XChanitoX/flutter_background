import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ejemplar.dart'; // Asegúrate de importar el modelo correcto

class IsarInstance {
  static Isar? _isar;

  // Método estático para obtener la instancia de Isar
  static Future<Isar> getInstance() async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [EjemplarSchema], // Asegúrate de que el esquema es el correcto
        directory: dir.path,
      );
    }
    return _isar!;
  }
}
