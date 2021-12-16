import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "DebitCardDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'debit_card';

  static final columnId = 'card_id';
  static final columnName = 'card_name';
  static final columnNumber = 'card_number';
  static final columnExpiryMonth = 'card_expirymon';
  static final columnExpiryYear = 'card_expiryyear';
  static final columnCvv = 'card_cvv';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance =
      new DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnNumber TEXT NOT NULL,
            $columnExpiryMonth TEXT NOT NULL,
            $columnExpiryYear TEXT NOT NULL,
            $columnCvv TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    var result = await db.query(table);
    return result.toList();
  }

  static queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> getcount(id) async {
    var dbclient = await instance.database;
    int count = Sqflite.firstIntValue(await dbclient
        .rawQuery("SELECT COUNT(*) FROM $table WHERE $columnId=$id"));
    return count;
  }
}
