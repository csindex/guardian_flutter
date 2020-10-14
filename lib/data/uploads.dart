class Uploads {

	int id;
  int notificationId;
	String file;
	String fileType;
	String tag;
	String fileFullPath;
  String createdAt;
  String updatedAt;

	Uploads.fromJsonMap(Map<String, dynamic> map):
		notificationId = map["notification_id"],
		id = map["id"],
		file = map["file"],
		fileType = map["file_type"],
		tag = map["tag"],
		fileFullPath = map["file_full_path"],
		createdAt = map["created_at"],
		updatedAt = map["updated_at"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['notification_id'] = notificationId;
		data['id'] = id;
		data['file'] = file;
		data['file_type'] = fileType;
		data['tag'] = tag;
		data['file_full_path'] = fileFullPath;
		data['created_at'] = createdAt;
		data['updated_at'] = updatedAt;
		return data;
	}

}
