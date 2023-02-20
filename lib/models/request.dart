
class Request {
  int? id;
  int? categoryId;
  int? cityId;
  int? minPrice;
  int? maxPrice;
  String? title;
  int? maxMeter;
  int? minMeter;
  int? status;
  String? description;
  int? userId;

  Request({this.id, this.categoryId, this.cityId, this.minPrice, this.maxPrice, this.title, this.maxMeter, this.minMeter, this.status, this.description, this.userId});

  Request.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["category_id"] is int) {
      categoryId = json["category_id"];
    }
    if(json["city_id"] is int) {
      cityId = json["city_id"];
    }
    if(json["minPrice"] is int) {
      minPrice = json["minPrice"];
    }
    if(json["maxPrice"] is int) {
      maxPrice = json["maxPrice"];
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["maxMeter"] is int) {
      maxMeter = json["maxMeter"];
    }
    if(json["minMeter"] is int) {
      minMeter = json["minMeter"];
    }
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["user_id"] is int) {
      userId = json["user_id"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["category_id"] = categoryId;
    _data["city_id"] = cityId;
    _data["minPrice"] = minPrice;
    _data["maxPrice"] = maxPrice;
    _data["title"] = title;
    _data["maxMeter"] = maxMeter;
    _data["minMeter"] = minMeter;
    _data["status"] = status;
    _data["description"] = description;
    _data["user_id"] = userId;
    return _data;
  }
}