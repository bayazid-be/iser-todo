import 'package:isar/isar.dart';
import 'package:isar_todo/model/todo.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  static late final Isar db;

  static Future<void> setUp() async {
    final appDir = await getApplicationDocumentsDirectory();
    db = await Isar.open([TodoSchema], directory: appDir.path);
  }
}
