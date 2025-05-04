import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notes/model/model.dart';

class TodoDatabase {
  static final instance = TodoDatabase._init();
  static Database? _database;
  TodoDatabase._init();
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb("todo.db");
    return _database!;
  }

  Future _initDb(String filePath) async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType = "BOOLEAN NOT NULL";
    const textType = "TEXT NOT NULL";
    await db.execute('''
      CREATE TABLE $tableName (
       ${TodoFields.id} $idType,
       ${TodoFields.isImportant} $boolType,
       ${TodoFields.title} $textType,
       ${TodoFields.description} $textType,
       ${TodoFields.time} $textType      
      )
      ''');
  }

  /// create operation
  Future<TodoModel> createTodo(TodoModel model) async {
    final db = await instance.database;
    final id = await db.insert(tableName, model.toJson());
    return model.copy(id: id);
  }

  /// read operation
  Future<TodoModel> readTodo(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableName, columns: TodoFields.values, where: "${TodoFields.id} = ?", whereArgs: [id]);

    if (maps.isNotEmpty) {
      return TodoModel.fromJson(maps.first);
    } else {
      throw Exception("Invalid input id :: $id");
    }
  }

  Future<List<TodoModel>> readAllTodo() async {
    final db = await instance.database;
    const orderBy = "${TodoFields.time} ASC";
    final result = await db.query(tableName, orderBy: orderBy);
    return result.map((e) => TodoModel.fromJson(e)).toList();
  }

  /// update
  Future<int> updateTodo(TodoModel model) async {
    final db = await instance.database;
    return await db.update(tableName, model.toJson(), where: "${TodoFields.id} = ?", whereArgs: [model.id]);
  }

  ///delete
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(tableName, where: "${TodoFields.id} = ?", whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
