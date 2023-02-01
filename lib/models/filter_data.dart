import 'dart:convert';

class FilterData {
  int? categoryId;
  List<int>? cityIds;
  bool? hasImage;
  bool? hasVideo;
  bool? hasTour;
  Filters? filters;
  String? search;

  FilterData({
    this.categoryId,
    this.cityIds,
    this.hasImage,
    this.hasVideo,
    this.hasTour,
    this.filters,
    this.search,
  });

  FilterData.fromJson(Map<String, dynamic> json) {
    if (json["category_id"] is int) {
      categoryId = json["category_id"];
    }
    if (json["city_ids"] is List) {
      cityIds =
          json["city_ids"] == null ? null : List<int>.from(json["city_ids"]);
    }
    if (json["hasImage"] is bool) {
      hasImage = json["hasImage"];
    }
    if (json["hasVideo"] is bool) {
      hasVideo = json["hasVideo"];
    }
    if (json["hasTour"] is bool) {
      hasTour = json["hasTour"];
    }
    if (json["filters"] is Map) {
      filters =
          json["filters"] == null ? null : Filters.fromJson(json["filters"]);
    }
    if (json["search"] is String) {
      hasVideo = json["search"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["category_id"] = categoryId;
    if (cityIds != null) {
      _data["city_ids"] = cityIds;
    }
    _data["hasImage"] = hasImage;
    _data["hasVideo"] = hasVideo;
    _data["hasTour"] = hasTour;
    if (filters != null) {
      _data["filters"] = filters?.toJson();
    }
    _data["search"] = search;
    return _data;
  }

  String toQueryString() {
    var str = "";

    if (categoryId != null) {
      str += getDelimiter(str) + "categoryId=${categoryId.toString()}";
    }

    if (cityIds != null) {
      str += getDelimiter(str) + "cityIds=" + jsonEncode(cityIds);
    }

    if (hasImage == true) {
      str += getDelimiter(str) + "hasImage=true";
    }

    if (hasVideo == true) {
      str += getDelimiter(str) + "hasVideo=true";
    }

    if (hasTour == true) {
      str += getDelimiter(str) + "hasTour=true";
    }

    if (search != null && search!.trim().isNotEmpty) {
      str += getDelimiter(str) + "title=" + search;
    }

    if (canConvert(filters)) {
      str += "&filters={";
      if (filters!.mater != null && filters!.mater!.isNotEmpty) {
        str += "\"mater\": " + jsonEncode(filters!.mater) + ",";
      }

      if (filters!.price != null && filters!.price!.isNotEmpty) {
        str += "\"price\": " + jsonEncode(filters!.price) + ",";
      }

      if (filters!.rent != null && filters!.rent!.isNotEmpty) {
        str += "\"rent\": " + jsonEncode(filters!.rent) + ",";
      }

      if (filters!.prices != null && filters!.prices!.isNotEmpty) {
        str += "\"prices\": " + jsonEncode(filters!.prices) + ",";
      }

      if (str.endsWith(",")) {
        str = str.substring(0, str.length - 1);
      }

      str += "}";
    }

    return str;
  }

  getDelimiter(String str) {
    if (str.isEmpty) {
      return "?";
    }
    return "&";
  }

  bool canConvert(Filters? filters) {
    if (filters != null &&
        ((filters.mater != null && filters.mater!.isNotEmpty) ||
            (filters.prices != null && filters.prices!.isNotEmpty) ||
            (filters.rent != null && filters.rent!.isNotEmpty) ||
            (filters.price != null && filters.price!.isNotEmpty))) {
      return true;
    }

    return false;
  }

  bool hasFilter() {
    return this.categoryId != null ||
        (this.hasImage ?? false) ||
        (this.hasVideo ?? false) ||
        (this.hasTour ?? false);
  }
}

class Filters {
  List<int>? mater;
  List<int>? price;
  List<int>? rent;
  List<int>? prices;

  Filters({this.mater, this.price, this.rent, this.prices});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json["mater"] is List) {
      mater = json["mater"] == null ? null : List<int>.from(json["mater"]);
    }
    if (json["price"] is List) {
      price = json["price"] == null ? null : List<int>.from(json["price"]);
    }
    if (json["rent"] is List) {
      rent = json["rent"] == null ? null : List<int>.from(json["rent"]);
    }
    if (json["prices"] is List) {
      prices = json["prices"] == null ? null : List<int>.from(json["prices"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (mater != null) {
      _data["mater"] = mater;
    }
    if (price != null) {
      _data["price"] = price;
    }
    if (rent != null) {
      _data["rent"] = rent;
    }
    if (prices != null) {
      _data["prices"] = prices;
    }
    return _data;
  }
}
