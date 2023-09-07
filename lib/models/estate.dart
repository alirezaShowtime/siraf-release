class Estate {
  int? id;
  String? lat;
  String? long;
  double? rate;
  String? name;
  String? phoneNumber;
  String? logo;
  String? address;
  String? managerName;
  String? telephoneNumber;
  int? cityId;

  Estate({
    this.id,
    this.lat,
    this.long,
    this.rate,
    this.name,
    this.phoneNumber,
    this.logo,
    this.address,
    this.managerName,
    this.telephoneNumber,
    this.cityId,
  });

  Estate.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["lat"] is String) {
      lat = json["lat"];
    }
    if (json["long"] is String) {
      long = json["long"];
    }
    if (json["rate"] is double) {
      rate = json["rate"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["phoneNumber"] is String) {
      phoneNumber = json["phoneNumber"];
    }
    if (json["logo"] is String) {
      logo = json["logo"];
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    if (json["managerName"] is String) {
      managerName = json["managerName"];
    }
    if (json["telephoneNumber"] is String) {
      telephoneNumber = json["telephoneNumber"];
    }
    if (json['cityId'] is int) {
      cityId = json['cityId'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["lat"] = lat;
    _data["long"] = long;
    _data["rate"] = rate;
    _data["name"] = name;
    _data["phoneNumber"] = phoneNumber;
    _data["logo"] = logo;
    _data["address"] = address;
    _data["managerName"] = managerName;
    return _data;
  }

  static List<Estate> fromList(List<dynamic> list) {
    var list2 = <Estate>[];

    for (dynamic item in list) {
      list2.add(Estate.fromJson(item));
    }

    return list2;
  }
}
