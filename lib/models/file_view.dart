class FileView {
  String? date;
  int? count;

  FileView({this.date, this.count});

  FileView.fromJson(Map<String, dynamic> json) {
    if (json["date"] is String) {
      date = json["date"];
    }
    if (json["count"] is int) {
      count = json["count"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["date"] = date;
    _data["count"] = count;
    return _data;
  }

  static List<FileView> fromList(List<dynamic> list) {
    var list2 = <FileView>[];

    for (dynamic item in list) {
      list2.add(FileView.fromJson(item));
    }

    return list2;
  }
}
