class ResponderData {
  String id;
  String opcen;
  String type;
  String date;

  ResponderData.fromJsonMap(Map<String, dynamic> map):
        id = map["_id"],
        opcen = map["opcen"],
        type = map["type"],
        date = map["date"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['opcen'] = opcen;
    data['type'] = type;
    data['date'] = date;
    return data;
  }
}
