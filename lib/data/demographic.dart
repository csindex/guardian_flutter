class Demographic {

  int notificationId;
  int ageFrom;
  int ageTo;
  int civilStatus;
  int gender;
  int bloodType;
  int employmentStatus;
  int privilegeStatus;
  int rank;
  int region;
  int province;
  int city;
  int barangay;
  String createdAt;
  String updatedAt;

	Demographic.fromJsonMap(Map<String, dynamic> map): 
		notificationId = map["notification_id"],
		ageFrom = map["age_from"],
		ageTo = map["age_to"],
		civilStatus = map["civil_status"],
		gender = map["gender"],
		bloodType = map["blood_type"],
		employmentStatus = map["employment_status"],
		privilegeStatus = map["privilege_status"],
		rank = map["rank"],
		region = map["region"],
		province = map["province"],
		city = map["city"],
		barangay = map["barangay"],
		createdAt = map["created_at"],
		updatedAt = map["updated_at"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['notification_id'] = notificationId;
		data['age_from'] = ageFrom;
		data['age_to'] = ageTo;
		data['civil_status'] = civilStatus;
		data['gender'] = gender;
		data['blood_type'] = bloodType;
		data['employment_status'] = employmentStatus;
		data['privilege_status'] = privilegeStatus;
		data['rank'] = rank;
		data['region'] = region;
		data['province'] = province;
		data['city'] = city;
		data['barangay'] = barangay;
		data['created_at'] = createdAt;
		data['updated_at'] = updatedAt;
		return data;
	}
}
