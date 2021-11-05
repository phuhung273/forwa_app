import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDB{

  abstract final String tableName;

  final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  final textType = 'TEXT NOT NULL';
  final integerType = 'INTEGER NOT NULL';

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, version: 1, onCreate: createDB, onConfigure: onConfigure);
  }

  Future createDB(Database db, int version);
  Future? onConfigure(Database db);
}