
class Estate {
  int? id;
  String? rate;
  String? name;
  String? phoneNumber;
  String? logo;
  String? address;
  String? managerName;

  Estate({this.id, this.rate, this.name, this.phoneNumber, this.logo, this.address, this.managerName});

  Estate.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["rate"] is String) {
      rate = json["rate"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["phoneNumber"] is String) {
      phoneNumber = json["phoneNumber"];
    }
    if(json["logo"] is String) {
      logo = json["logo"];
    }
    if(json["address"] is String) {
      address = json["address"];
    }
    if(json["managerName"] is String) {
      managerName = json["managerName"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
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