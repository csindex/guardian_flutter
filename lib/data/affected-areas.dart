class AffectedAreas {

  int id;
  int notificationId;
  String location;
  double latitude;
  double longitude;
  int radius;
  String createdAt;
  String updatedAt;

  AffectedAreas.fromJsonMap(Map<String, dynamic> map):
        notificationId = map["notification_id"],
        id = map["id"],
        location = map["location"],
        latitude = map["latitude"],
        longitude = map["longitude"],
        radius = map["radius"],
        createdAt = map["created_at"],
        updatedAt = map["updated_at"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = notificationId;
    data['id'] = id;
    data['location'] = location;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['radius'] = radius;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

}
