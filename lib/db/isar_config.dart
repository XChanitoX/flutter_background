import 'package:isar/isar.dart'; // Importa la biblioteca Isar, que maneja la base de datos local.
import 'package:path_provider/path_provider.dart'; // Importa la biblioteca para obtener directorios en el dispositivo.
import '../models/ejemplar.dart'; // Importa el modelo Ejemplar, que representa la estructura de los datos en la base de datos.

// Función asíncrona que abre y configura la base de datos Isar.
Future<Isar> openIsar() async {
  // Obtiene el directorio de documentos de la aplicación, donde se almacenarán los archivos de la base de datos.
  final dir = await getApplicationDocumentsDirectory();

  // Abre la base de datos Isar utilizando el esquema de Ejemplar y el directorio obtenido.
  return await Isar.open(
    [
      EjemplarSchema
    ], // Esquema que define la estructura de los datos (modelo Ejemplar).
    directory: dir.path, // Ruta donde se guardará la base de datos.
  );
}
