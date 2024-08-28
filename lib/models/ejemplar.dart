import 'package:isar/isar.dart';

part 'ejemplar.g.dart';

@Collection()
class Ejemplar {
  Id id = Isar.autoIncrement;

  late String nombre;

  Ejemplar({required this.nombre});
}
