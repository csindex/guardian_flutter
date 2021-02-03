class EducationData {
  String id;
  String school;
  String degree;
  String fieldOfStudy;
  String dateFrom;
  String dateTo;
  bool current;
  String description;

  EducationData.fromJsonMap(Map<String, dynamic> map)
      : id = map["_id"],
        school = map["school"],
        degree = map["degree"],
        fieldOfStudy = map["fieldofstudy"],
        dateFrom = map["from"],
        dateTo = map["to"],
        current = map["current"],
        description = map["description"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = id;
    data['school'] = school;
    data['degree'] = degree;
    data['fieldofstudy'] = fieldOfStudy;
    data['from'] = dateFrom;
    data['to'] = dateTo;
    data['current'] = current;
    data['description'] = description;
    return data;
  }
}
