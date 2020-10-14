class Details {

  int notificationId;
  int isDefault;
  int isHidden;
  int isDraft;
  int isSend;
  int isSchedule;
  int copyAnnouncement;
  int copySms;
  String createdAt;
  String updatedAt;

	Details.fromJsonMap(Map<String, dynamic> map): 
		notificationId = map["notification_id"],
		isDefault = map["is_default"],
		isHidden = map["is_hidden"],
		isDraft = map["is_draft"],
		isSend = map["is_send"],
		isSchedule = map["is_schedule"],
		copyAnnouncement = map["copy_announcement"],
		copySms = map["copy_sms"],
		createdAt = map["created_at"],
		updatedAt = map["updated_at"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['notification_id'] = notificationId;
		data['is_default'] = isDefault;
		data['is_hidden'] = isHidden;
		data['is_draft'] = isDraft;
		data['is_send'] = isSend;
		data['is_schedule'] = isSchedule;
		data['copy_announcement'] = copyAnnouncement;
		data['copy_sms'] = copySms;
		data['created_at'] = createdAt;
		data['updated_at'] = updatedAt;
		return data;
	}
}
