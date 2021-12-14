import 'package:sqflite/sqflite.dart';

import 'base_db.dart';


const DB_NAME = 'hidden_users';
const COLUMN_ID = 'id';
const COLUMN_USER_ID = 'user_id';

class HiddenUserDB extends BaseDB{

  @override
  String tableName = DB_NAME;

  final columnID = COLUMN_ID;
  final columnUserId = COLUMN_USER_ID;

  static final HiddenUserDB instance = HiddenUserDB._init();

  HiddenUserDB._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB('$tableName.db');
    return _database!;
  }

  @override
  Future createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tableName (
          $columnID $idType,
          $columnUserId $integerType
        )
    ''');
  }

  @override
  Future? onConfigure(Database db) {
  }

  Future<List<int>> getAll() async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) => maps[i][COLUMN_USER_ID]);
  }

  Future<int> insert(int id) async {
    final db = await instance.database;

    return db.insert(tableName, {COLUMN_USER_ID: id});
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(tableName, where: '$columnID = ?', whereArgs: [id]);
  }

  Future clear() async {
    final db = await instance.database;

    db.delete(tableName);
  }

}