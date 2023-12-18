import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper{
  static final String  _DB_NAME="github.db";
  static var status = '';
  static final _DB_VERSION = 1;

  static const table_repository = 'repository';


  String? dbpath;




  //Constructor
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _DB_NAME);
    dbpath=path;

    //Check existing
    var exists = await databaseExists(path);
    if (!exists) {
      status = "Creating Database";

      //If not exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      //copy database
      ByteData data = await rootBundle.load(join("assets/db", _DB_NAME));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      //Write
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      status = "Opening existing database";
      print('Opening existing database');
    }

    return await openDatabase(path, version: _DB_VERSION);
  }

  Future<void> insertList({String? tableName,List<Map<String, dynamic>>? dataList,required bool deleteBeforeInsert}) async {
    Database? db = await instance.database;
    Batch batch = db!.batch();

    if (deleteBeforeInsert) {
      await deleteAll(tableName: tableName);
    }

    for (final data in dataList!) {
     // print(data);
      batch.insert(tableName??"", data,conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit(continueOnError: true, noResult: true);
  }


  Future<List> getAll(String tbl) async {
    Database? db = await instance.database;
    var result = await db!.query(tbl);
    return result.toList();
  }

  Future<List> getAllWithLimit(String tbl) async {
    Database? db = await instance.database;
    var result = await db!.query(tbl);
    return result.toList();
  }

  //Delete all
  Future<int> deleteAll({String? tableName}) async {
    Database? db = await instance.database;
    return await db!.rawDelete("DELETE FROM $tableName");
  }

  //Delete all where
  Future<int> deleteAllWhr(String tbl, String where, List whereArgs) async {
    Database? db = await instance.database;
    return await db!.rawDelete("DELETE FROM $tbl WHERE $where", whereArgs);
  }

  //get all where
  Future<List> getAllWhr({required String tbl, required String where, required List whereArgs}) async {
    print(where);
    Database? db = await instance.database;
    return await db!.rawQuery("SELECT *FROM $tbl WHERE $where", whereArgs);
  }

  //update where
  Future<int> updateWhere({required String tbl,required Map<String,dynamic> data, required String where, required List whereArgs}) async {

    Database? db = await instance.database;
    return await db!.update(tbl, data,where: where,whereArgs: whereArgs);
  }

  Future<int> getItemCount({String? tableName}) async {
    Database? db = await instance.database;
    final result = await db!.rawQuery('SELECT COUNT(*) FROM $tableName');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> deleteDatabase(String path) => databaseFactory.deleteDatabase(path);

  Future<List> find(String tbl, String whr, List whrArgs) async {
    Database? db = await instance.database;
    var result = await db!.query(tbl, where: whr, whereArgs: whrArgs);
    return result.toList();
  }


}
