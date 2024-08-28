import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/ejemplar.dart';

Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [EjemplarSchema],
    directory: dir.path,
  );
}
