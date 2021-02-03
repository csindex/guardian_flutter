class ExperienceData {
  String id;
  String title;
  String company;
  String location;
  String dateFrom;
  String dateTo;
  bool current;
  String description;

  ExperienceData.fromJsonMap(Map<String, dynamic> map)
      : id = map["_id"],
        title = map["title"],
        company = map["company"],
        location = map["location"],
        dateFrom = map["from"],
        dateTo = map["to"],
        current = map["current"],
        description = map["description"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['title'] = title;
    data['company'] = company;
    data['location'] = location;
    data['from'] = dateFrom;
    data['to'] = dateTo;
    data['current'] = current;
    data['description'] = description;
    return data;
  }
}
