import 'dart:convert';

import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';

class FilterData {
  Category? mainCategory;
  Category? category;
  List<int>? cityIds;
  bool? hasImage;
  bool? hasVideo;
  bool? hasTour;
  Filters? filters;
  String? search;
  int? estateId;
  int? consultantId;

  FilterData({
    this.category,
    this.cityIds,
    this.hasImage,
    this.hasVideo,
    this.hasTour,
    this.filters,
    this.search,
    this.estateId,
    this.consultantId,
  });

  String toQueryString() {
    var str = "";

    if (category != null) {
      if (category!.isAll ?? false) {
        str += getDelimiter(str) + "categoryId=${mainCategory!.id.toString()}";
      } else {
        str += getDelimiter(str) + "categoryId=${category!.id.toString()}";
      }
    }

    if (cityIds != null) {
      str += getDelimiter(str) + "cityIds=" + "[" + cityIds!.join(',') + "]";
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

    if (estateId != null) {
      str += getDelimiter(str) + "estateId=$estateId";
    }

    if (consultantId != null) {
      str += getDelimiter(str) + "consultantId=$consultantId";
    }

    if (search != null && search!.trim().isNotEmpty) {
      str += getDelimiter(str) + "title=" + search;
    }

    if (canConvert(filters)) {
      str += "&filters={";
      if (filters!.mater != null && filters!.mater!.isNotEmpty) {
        str +=
            "\"mater\":" + jsonEncode(filters!.mater).replaceAll(' ', '') + ",";
      }

      if (filters!.price != null && filters!.price!.isNotEmpty) {
        str +=
            "\"price\":" + jsonEncode(filters!.price).replaceAll(' ', '') + ",";
      }

      if (filters!.rent != null && filters!.rent!.isNotEmpty) {
        str +=
            "\"rent\":" + jsonEncode(filters!.rent).replaceAll(' ', '') + ",";
      }

      if (filters!.prices != null && filters!.prices!.isNotEmpty) {
        str += "\"prices\":" +
            jsonEncode(filters!.prices).replaceAll(' ', '') +
            ",";
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
    return this.category?.id != null ||
        (this.hasImage ?? false) ||
        (this.hasVideo ?? false) ||
        (this.hasTour ?? false);
  }

  int filterCount() {
    int count = 0;

    if (hasImage ?? false) count++;
    if (hasVideo ?? false) count++;
    if (hasTour ?? false) count++;

    if (filters?.mater.isNotNullOrEmpty() ?? false) count++;

    if ((filters?.price.isNotNullOrEmpty() ?? false) ||
        (filters?.prices.isNotNullOrEmpty() ?? false) ||
        (filters?.rent.isNotNullOrEmpty() ?? false)) count++;

    if (category != null || mainCategory != null) count++;

    return count;
  }
}

class Filters {
  List<int>? mater;
  List<int>? price;
  List<int>? rent;
  List<int>? prices;

  Filters({this.mater, this.price, this.rent, this.prices});
}
