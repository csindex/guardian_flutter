import 'details.dart';
import 'demographic.dart';
import 'uploads.dart';
import 'affected-areas.dart';

class Data {

  int id;
  int userId;
  int roleId;
  int commandCenterId;
  int incidentType;
  int departmentId;
  int broadcast;
  int notificationType;
  int notificationSubType;
  int severity;
  String title;
  int drawOption;
  String whatTodo;
  String imagePath;
  String imageShare;
  String createdAt;
  String updatedAt;
  String imageFullPath;
  Details details;
  Demographic demographic;
  List<AffectedAreas> affectedAreas;
  List<Uploads> uploads;
  List<Object> comments;

	Data.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		userId = map["user_id"],
		roleId = map["role_id"],
		commandCenterId = map["commandcenter_id"],
		incidentType = map["incident_type"],
		departmentId = map["department_id"],
		broadcast = map["broadcast"],
		notificationType = map["notification_type"],
		notificationSubType = map["notification_sub_type"],
		severity = map["severity"],
		title = map["title"],
		drawOption = map["draw_option"],
		whatTodo = map["what_todo"],
		imagePath = map["image_path"],
		imageShare = map["image_share"],
		createdAt = map["created_at"],
		updatedAt = map["updated_at"],
		imageFullPath = map["image_full_path"],
		details = Details.fromJsonMap(map["details"]),
		demographic = Demographic.fromJsonMap(map["demographic"]),
		affectedAreas = List<AffectedAreas>.from(map["affectedareas"].map((it) => AffectedAreas.fromJsonMap(it))),
		uploads = List<Uploads>.from(map["uploads"].map((it) => Uploads.fromJsonMap(it))),
		comments = map["comments"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['user_id'] = userId;
		data['role_id'] = roleId;
		data['commandcenter_id'] = commandCenterId;
		data['incident_type'] = incidentType;
		data['department_id'] = departmentId;
		data['broadcast'] = broadcast;
		data['notification_type'] = notificationType;
		data['notification_sub_type'] = notificationSubType;
		data['severity'] = severity;
		data['title'] = title;
		data['draw_option'] = drawOption;
		data['what_todo'] = whatTodo;
		data['image_path'] = imagePath;
		data['image_share'] = imageShare;
		data['created_at'] = createdAt;
		data['updated_at'] = updatedAt;
		data['image_full_path'] = imageFullPath;
		data['details'] = details == null ? null : details.toJson();
		data['demographic'] = demographic == null ? null : demographic.toJson();
		data['affectedareas'] = affectedAreas;
		data['uploads'] = uploads;
		data['comments'] = comments;
		return data;
	}
}
