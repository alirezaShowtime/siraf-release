import 'package:siraf3/db/database.dart';

class SearchHistory {
  static const String table = "search_histories";

  String keyword;

  SearchHistory(String this.keyword);

  static Future<void> createIfNotExist(String keyword) async {
    if (await isExist(keyword)) {
      return;
    }
    await (await SQLiteDbProvider.sqLiteDbProvider.database).insert(table, {
      "keyword": keyword,
    });
  }

  static Future<void> truncate() async {
    await (await SQLiteDbProvider.sqLiteDbProvider.database).execute("DELETE FROM `$table`;");
  }

  static Future<List<SearchHistory>> all({String orderById = "desc"}) async {
    List<Map<String, Object?>> result = await (await SQLiteDbProvider.sqLiteDbProvider.database).query(table, orderBy: "id $orderById");
    List<SearchHistory> models = [];

    result.forEach((item) {
      models.add(SearchHistory(item["keyword"]! as String));
    });

    return models;
  }

  static Future<bool> isExist(String keyword) async {
    var result = await (await SQLiteDbProvider.sqLiteDbProvider.database).rawQuery("SELECT * FROM $table WHERE keyword = '$keyword';");

    return result.length > 0;
  }
}
