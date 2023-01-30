import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model/search_history.dart';

class SQLiteDbProvider {
  SQLiteDbProvider._();

  static final SQLiteDbProvider sqLiteDbProvider = SQLiteDbProvider._();

  static Database? _database = null;

  static const String _databaseName = "siraf.db";
  static const int _databaseVersion = 1;

  static const _tableCreatorQuery = [
    "CREATE TABLE `${SearchHistory.table}`("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "keyword TEXT NOT NULL,"
        "created_at DATETIME DEFAULT CURRENT_TIMESTAMP"
        ");",
  ];

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDB();
    }
    return _database!;
  }

  _initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        _tableCreatorQuery.forEach((query) async {
          await db.execute(query);

          print("tables are created");
        });
      },
    );
  }
}
